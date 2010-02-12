Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0BLT3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:29:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421Ab0BLT3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:29:46 -0500
Date: Fri, 12 Feb 2010 11:29:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] delayacct: align to 8 byte boundary on 64-bit systems
Message-Id: <20100212112912.be58b670.akpm@linux-foundation.org>
In-Reply-To: <4B75A9F7.4030607@suse.com>
References: <4B75865B.8000307@suse.com>
	<20100212101957.9f4a4a3a.akpm@linux-foundation.org>
	<4B75A9F7.4030607@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 14:20:23 -0500
Jeff Mahoney <jeffm@suse.com> wrote:

> > Seems safe enough.  We'd be safer still if we didn't do this on 64-bit
> > architectures which don't need it.  ie: x86_64.  But if we do that we
> > add a risk that people will develop shoddy code which works on x86_64
> > and doesn't work on ia64.
> 
> Is there a way to do that without needlessly complicating things? I
> didn't see any existing infrastructure to do that.

ifdefs?  I don't think it's worth doing, really.  Probably anyone who
wrote an application for this copied the getdelays.c code anyway.
