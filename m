Return-Path: <linux-kernel-owner+w=401wt.eu-S1422950AbXDRMNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422950AbXDRMNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422958AbXDRMNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:13:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40755 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422950AbXDRMNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:13:21 -0400
Date: Wed, 18 Apr 2007 14:11:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@novell.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add keyboard blink driver
Message-ID: <20070418121153.GA2258@elf.ucw.cz>
References: <200704121727.27892.ak@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704121727.27892.ak@novell.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add a blink driver for debugging
> 
> Simple driver that blinks the keyboard LEDs when loaded. Useful
> for checking that the kernel is still alive or for crashdumping.

For checking if kernel is alive/crashdumping... can user just do
setleds +caps; sleep 1; setleds -caps; ... ? You can even have morse
code :-).

Besides, we now have led support framework in kernel, that can do
blinking by itself etc.
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
