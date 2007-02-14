Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbXBNLIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbXBNLIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 06:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXBNLIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 06:08:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49821 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750892AbXBNLIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 06:08:41 -0500
Date: Wed, 14 Feb 2007 12:07:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: akuster <akuster@mvista.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070214110730.GA21620@elf.ucw.cz>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070203100848.GA28806@infradead.org> <45C53841.5000505@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C53841.5000505@mvista.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>This adds the ability for the file system to remounted as read only 
> >>during a
> >>system suspend.  Log the mount points so when the resume occurs, they can 
> >>be remounted back to their original states. This is so in an advent of a 
> >>power
> >>failure, we try our best to keep data from being corrupted or lost.
> >
> >Can you please explain why this can't be done in userspace?  
> 
> I am sure it can.  The idea came from customer inputs, speed is my 
> guess. echo mem > /sys/../state seems a whole lot simpler and cleaner 
> than having userspace figure out what it mounted and then doing echo
>mem.

Well, customers have little knowledge of linux kernel, sorry.

Do it in userspace, then find out if it is too slow, and if it is,
develop extensions to kernel to do it properly.

But no, you can't simply do it in kernel.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
