Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYGFR0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYGFR0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYGFRZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:25:55 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46924 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752677AbYGFRZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:25:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EpNkG6I4k15ciqJdqROGHdLMqcWiyfcViN81dttbHdYhZVlpTpQD/vAv4bKbGlbr7ZsXWJXeS7aNMDhBKmZ9qvpVufoLQJP6+FmfP6KJEvRbKjbvA90zcQTH7yK0wW8atopY1tquUTz8i2kYMBusrL+C6N7IHhmn1F48UjP6cHI=  ;
X-YMail-OSG: mDd0ftUVM1nMsOT8jkp38zXbn..IIB0nNIrWsByOH1fpXeUrjY7Q0WZleAK_mKilu1679A3dlQvJEK2Pe7GVnpqqleHYs6b9MmnGM1CguA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
Date: Sun, 6 Jul 2008 10:25:52 -0700
User-Agent: KMail/1.9.9
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <200807051108.20183.arvidjaar@mail.ru> <200807060859.58971.arvidjaar@mail.ru> <alpine.LFD.1.10.0807052212200.3016@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807052212200.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807061025.52560.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2008, Linus Torvalds wrote:
> Greg, Alan, David - at this point I think the commit should just be 
> reverted. We're past -rc9, and unless either of you can see some obvious 
> alternate fix (eg some bug in the commit that explains Adrey's problems 
> that can just be fixed), I'm not seeing any good alternatives.

Right.  I tried RC9 on some OHCI hardware I have locally,
and none of it seems to have this problem.  If I had more
PCI slots, I could test more OHCI silicon ... but those
are going the way of the serial port (at least on PCs).

The only regresion I uncovered is that my OMAP1 OSK stopped
booting sometime after RC2; that's not because of OHCI.


> I don't know what the hardware details are, but based on the bootup 
> messages it seems to be a Toshiba motherboatd with an ALI 1535 chipset - I 
> think it's a Toshiba Portege 4000 (which would mean that the OHCI 
> controller is the ALI M5237).

I don't recall anything unusual about ALI and OHCI.  They
worked fine for me in some K6 and K7 hardware I had back
then ... then they got renamed to ULI, bought by NVidia,
and killed.

- Dave

