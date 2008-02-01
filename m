Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYBAP2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYBAP2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYBAP2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:28:08 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20122 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYBAP2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:28:06 -0500
Message-ID: <47A33A85.5020308@msgid.tls.msk.ru>
Date: Fri, 01 Feb 2008 18:28:05 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: swsusp on an AMD x2-64, 2.6.24: regression?
References: <47A24072.4090001@msgid.tls.msk.ru> <20080131231219.GA14355@elf.ucw.cz> <47A2F168.8070407@msgid.tls.msk.ru> <200802011225.11571.rjw@sisk.pl> <47A33512.8050401@msgid.tls.msk.ru>
In-Reply-To: <47A33512.8050401@msgid.tls.msk.ru>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Rafael J. Wysocki wrote:
[]
>> I guess it's a special variation of
>> http://bugzilla.kernel.org/show_bug.cgi?id=9528
>>
>> Please try to hibernate in the shutdown mode (ie. echo
>> "shutdown" into /sys/power/disk before hibernation).

[yes it works with shutdown...]

> In any way, this is definitely progress, and that bug
> seems to be the same as I'm seeing here.
> 
> Now... I see there's a new BIOS for this mobo available
> (it's ASUS M2NPV-VM motherboard, Geforce6150/Nforce430(?)),
> which is more recent compared with what I have here.  Trying
> it now (will try to reflash it without a floppy - it turns
> out to be quite.. challenging task ;)

Ok, updated the bios (using freedos virtual boot floppy provided
by memdisk from syslinux), and... now it all works correctly!

I was definitely blaming linux for the regression - obviously,
as "before-kernel" worked, while "current-kernel" does not
anymore.  But the problem seems to be due to some bios buglet.
Oh well... ;)

> Thanks!
!

Now I can go on with my other.. question, namely the UPS thingie... :)

/mjt
