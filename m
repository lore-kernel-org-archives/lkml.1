Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXLOWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXLOWzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXLOWz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:55:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35324 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752539AbXLOWz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:55:27 -0500
Date: Sat, 15 Dec 2007 23:55:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       rol@witbe.net
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071215225538.GC2434@elf.ucw.cz>
References: <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47643872.5070703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47643872.5070703@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-12-15 12:26:26, H. Peter Anvin wrote:
> Paul Rolland wrote:
>> Just an idea : from what I've read, the problem (port 80 hanging) only 
>> occurs
>> on 'modern' machines...
>
> It happens on *one single* "modern" machine...
>
> Let's keep that in perspective.

it hurts on other machines (like debug leds being useless), and it may
be incorrect as soon as you insert leds-on-port-0x80-on-PCI card.

No, it is not critical but yes, I'd like to see it fixed.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
