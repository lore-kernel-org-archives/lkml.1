Return-Path: <linux-kernel-owner+w=401wt.eu-S965927AbXBOM16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965927AbXBOM16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965926AbXBOM16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:27:58 -0500
Received: from picard.linux.it ([213.254.12.146]:52032 "EHLO picard.linux.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965927AbXBOM16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:27:58 -0500
X-Greylist: delayed 1904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 07:27:57 EST
Message-ID: <37556.85.47.20.193.1171540572.squirrel@picard.linux.it>
In-Reply-To: <20070215103639.GB27338@elf.ucw.cz>
References: <45D43489.3060409@l4x.org> <20070215103639.GB27338@elf.ucw.cz>
Date: Thu, 15 Feb 2007 12:56:12 +0100 (CET)
Subject: Re: [linux-pm] Suspend to RAM, Sony Vaio PCG-SRX51P, lcd stays off
From: "Mattia Dongili" <malattia@linux.it>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Jan Dittmer" <jdi@l4x.org>, stelian@popies.net,
       linux-acpi@vger.kernel.org, linux-pm@osdl.org, adaplas@pol.net,
       dawes@xfree86.org, "Linux kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 15, 2007 11:36 am, Pavel Machek said:
> Hi!
>
>> I own an older Sony Vaio SRX51P, European Model, P3 based. s2ram
>> identifies it with
>>
>>     sys_vendor   = "Sony Corporation    "
>>     sys_product  = "PCG-SRX51P(DE)      "
>>     sys_version  = "01                  "
>>     bios_version = "R0232U2"
>>
>> Suspend to RAM by using "s2ram -v -m -f" actually works and the
>> laptop comes back to life, is accessible by network, etc. kudos
>> so far.
>> The only but serious problem is, that the lcd stays off after
>> resume. No matter what kind of options for s2ram I try, if I disable
>
> Is the _lcd_ off or the _backlight_ off? Use bright flashlight to
> tell.
>
>> framebuffer or suspend from X, the lcd always stays off. Only
>> a reboot fixes this. Note that the X driver also cannot dis-/enable
>> the lcd (xset dpms force off). It always stays lit. I also tried
>> with i810switch, but that also does not affect the lcd.
>> spicctrl -b42 neither.

(unrelated to your suspend problems) does the sony-laptop (formerly
sony_acpi) module helps controlling brightness?
(should appear soon or you can eventually grab it from the linux-acpi tree)

>> Latest kernel I tested is 2.6.20-git11 from today.

I read reports of successful suspends on that laptop, eg:
http://freenet-homepage.de/obauer/index.html

-- 
mattia
:wq!


