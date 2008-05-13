Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbYEMUt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbYEMUt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbYEMUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:49:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758648AbYEMUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:49:17 -0400
Date: Tue, 13 May 2008 13:43:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Helsley <matthltc@us.ibm.com>
Cc: menage@google.com, pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com,
       serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups
 control files
Message-Id: <20080513134354.18d3f6a3.akpm@linux-foundation.org>
In-Reply-To: <1210711138.21217.49.camel@localhost.localdomain>
References: <20080513063707.049448000@menage.corp.google.com>
	<20080513071522.133586000@menage.corp.google.com>
	<20080513130127.fcd46a41.akpm@linux-foundation.org>
	<1210711138.21217.49.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 13:38:58 -0700
Matthew Helsley <matthltc@us.ibm.com> wrote:

> > > +	char static_buffer[64];
>
> > I'm trying to work out what protects static_buffer?
> 
> One of us must be having a brain cramp because it looks to me like the
> buffer doesn't need protection -- it's on the stack. It's probably me
> but I'm just not seeing how this use is unsafe..

doh.  Well it had me going...

> Uh, it is on stack. It doesn't use the C keyword "static". It's just
> poorly-named.

That depends upon one's objectives in choosing a name ;)
