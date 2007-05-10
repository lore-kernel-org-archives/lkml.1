Return-Path: <linux-kernel-owner+w=401wt.eu-S1761831AbXEJUHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831AbXEJUHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760385AbXEJUHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:07:34 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:46576 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759443AbXEJUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:07:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e4fd+RfxP+ns+emH8idUGfEgFJVnuMXhlsueUEjhZNjgqOPq4Nen+/tE/opLvz1RMRXCjnW3u6XWOkp2R5llWi3CtNx3ah+DaqHKJzSLOAysswKOaf3L0asI23rZ1GzP8VEfS6bkqjEMlAVCUBVIjub1AeswItkJIkVRfPZ2W4M=  ;
X-YMail-OSG: leb8joIVM1nBrQX3GrImWu4dZ0HTCZNUvxKVs18IvNaODMmRLEWiJqymtjYW5yCqOzqArpZ16auoWHfCdFJfKQXRJbY6Q6cce.kNz6ewGjILwKOBT3iXD3uUmeCm4w--
From: David Brownell <david-b@pacbell.net>
To: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Subject: Re: drivers/mtd/devices/at91_dataflash26.c
Date: Thu, 10 May 2007 13:07:19 -0700
User-Agent: KMail/1.9.6
Cc: dwmw2@infradead.org, Andrew Victor <andrew@sanpeople.com>,
       tglx@linutronix.de, Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704271812.26392.david-b@pacbell.net> <200704280336.44913.hjk@linutronix.de> <200704271908.17403.david-b@pacbell.net>
In-Reply-To: <200704271908.17403.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200705101307.19794.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007, David Brownell wrote:
> On Friday 27 April 2007, Hans-Jürgen Koch wrote:
> 
> > > 	 the m25p80 driver
> > > was pretty close to working with those Atmel devices too ...
> > > most of the commands are identical.
> > 
> > Thanks for that hint, I'll have a look at the data sheet.

Any progress on that?  I looked again, and yes most commands
are identical.

 - That driver relies on an AT91-only SPI stack that's not
   going upstream, instead of drivers/spi/atmel_spi.c;

 - Driver can't even be selected on kernel.org kernel (!!);

 - The m25p80 driver will need at most minor tweaks to
   handle those AT26 (and AT25) series chips;

So 340ea370c2ce89d1c15fbf785460f2f74314ce58 should be reverted.

- Dave
