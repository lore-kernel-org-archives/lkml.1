Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbXH0MJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbXH0MJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbXH0MId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:08:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47666 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756164AbXH0MIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:08:32 -0400
Date: Mon, 27 Aug 2007 09:53:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: vgoyal@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2 -mm] kexec based hibernation
Message-ID: <20070827075317.GB2060@elf.ucw.cz>
References: <1188177245.3247.36.camel@caritas-dev.intel.com> <20070827050027.GB9809@in.ibm.com> <1188195529.3247.82.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188195529.3247.82.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Does this make sense?
> 
> Yes, this is a sensible optimization. But I think it may be better to
> make bootloader load kernel D directly into a specified memory location.
> For example, we can add a option to "kernel" command of grub. 
> 
> And, I think we can do more in bootloader. Such as we can prepare
> two

Yes, that would be nice.

It will mean quite a bit of work, but I guess it should be the long
term goal. Loading restore kernel directly from bootloader means:

1) it is fast -- no need to boot another kernel

2) it is "classical" way of doing things

On the other hand, we loose flexibility that way:

1) it locks you onto one bootloader

2) you no longer have userland there to do uncompression, decryption,
etc..
									Pave
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
