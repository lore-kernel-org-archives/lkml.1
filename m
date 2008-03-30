Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYC3VwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYC3VwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYC3Vvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:51:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbYC3Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:51:52 -0400
Date: Sun, 30 Mar 2008 14:51:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when getting
 disconnected
In-Reply-To: <20080330184259.GB21375@atjola.homenet>
Message-ID: <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
References: <20080330184259.GB21375@atjola.homenet>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Mar 2008, Bj?rn Steinbrink wrote:
>
> I can't reproduce the bug on my UP box and currently can't afford
> crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> guess it needs SMP to crash), so while this doesn't show any new
> problems, I can't tell whether it actually fixes anything. Testers
> welcome!

Ok, I applied this because I will do an -rc8 today or tomorrow, but I 
really really hope somebody can figure out what made this all start to 
trigger. It does smell like some core device layer change, because we do 
not seem to have a lot of changes since 2.6.24 in evdev.c and input.c that 
seem relevant.

Greg, are there any refcounting changes that would cause the input devices 
to be free'd earlier or something?

		Linus
