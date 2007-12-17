Return-Path: <linux-kernel-owner+w=401wt.eu-S937311AbXLQXUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937311AbXLQXUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763520AbXLQXUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:20:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48130 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753445AbXLQXUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:20:20 -0500
Date: Tue, 18 Dec 2007 00:20:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rene Herman <rene.herman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071217232011.GB12647@elf.ucw.cz>
References: <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <4766E453.1030202@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766E453.1030202@keyaccess.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-17 22:04:19, Rene Herman wrote:
> On 15-12-07 00:29, Alan Cox wrote:
>
>>>> ?? Just initialize bogomips to 6GHz equivalent... and we are fine
>>>> until 6GHz cpus come out.
>>> How long will that take to boot on a 386?
>> Well the dumb approach to fix that would seem to be to initialise it to
>> 	cpu->family   3 -> 50MHz 4 -> 300Mhz 5-> etc...
>
> By the way, you have a 300 MHz 486? I believe 3 -> 40, 4 -> 133, 5 -> 233 
> would be good? And I'm not really sure about the etc. P6 has a large range 
> again...

Some nexgen 5x86 boxes were pretty fast, still could not do 486... so
family 3 iirc.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
