Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157Ab0ANFgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0ANFgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956Ab0ANFgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:36:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58418 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0ANFgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:36:52 -0500
Date: Thu, 14 Jan 2010 05:36:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: vapier@gentoo.org, lethal@linux-sh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] NOMMU: Fix SYSV SHM for NOMMU
Message-ID: <20100114053634.GA15972@ZenIV.linux.org.uk>
References: <20100108220516.23489.11319.stgit@warthog.procyon.org.uk>
 <23917.1262988613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23917.1262988613@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 10:10:13PM +0000, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > Put it back conditionally on CONFIG_MMU=n.
> 
> Seems I forgot to put in the conditional bits.  Revised patch attached.

Series looks sane...  ACK on the entire bunch
