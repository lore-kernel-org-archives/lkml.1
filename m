Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYAYUXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYAYUXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYAYUXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:23:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578AbYAYUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:23:33 -0500
Date: Fri, 25 Jan 2008 12:23:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
In-Reply-To: <20080125194219.GA4596@suse.de>
Message-ID: <alpine.LFD.1.00.0801251221210.2979@hp.linux-foundation.org>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125194219.GA4596@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jan 2008, Greg KH wrote:

> On Fri, Jan 25, 2008 at 10:44:59AM -0800, Linus Torvalds wrote:
> > 
> >  - from the purely broken ones:
> > 
> > 	ehci_hcd: no version for "struct_module" found: kernel tainted.
> 
> Ok, in looking at the code, this should also be showing up for you on a
> "clean" 2.6.24 release, I didn't change anything in this code path.

Ok, I just never noticed, because without any warnings or oopses, it 
didn't much matter...

> Linus, does the patch below (built tested only) fix the above call trace
> noise for you?  It shouldn't change the taint flag, that's a different
> issue it seems.

Sadly, I'm now in the process of shutting down all my machines to prepare 
for "the flight from hell(tm)", so I won't have time to check this right 
now.

		Linus
