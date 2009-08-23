Return-Path: <linux-kernel-owner+w=401wt.eu-S933689AbZHWN1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689AbZHWN1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933644AbZHWN1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:27:34 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43674 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933643AbZHWN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=cmlrLHFOnQazM5M3hGCNJteC7yB0+7JYAN0DO+illaFUUSeflXIypCS5mGF+Ppz47W
         JaqdLEYQNlmDfDoSajr0Yiwfq8QuP9uKPWjvUt/9WotEVvs+7nCk4cDeEFvq4p8DxMcv
         oT09pDY35C8iftzsxm3RkRaSHxqR/IJQFq4G4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/22] Staging: rt{286,287,307}0: various fixes/cleanups
Date: Sun, 23 Aug 2009 15:18:36 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc7-dirty; KDE/4.2.4; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain> <200908192125.59395.bzolnier@gmail.com> <1250747041.7517.33.camel@marge.simson.net>
In-Reply-To: <1250747041.7517.33.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908231518.36476.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009 07:44:01 Mike Galbraith wrote:
> On Wed, 2009-08-19 at 21:25 +0200, Bartlomiej Zolnierkiewicz wrote: 
> 
> > Thanks a lot for extra testing, could you also check what MAC version is
> > this beast using?  I'm now working on merging rt2870 and rt3070 together,
> > and I would need somebody with 2870 flavor to verify the end result.. :)
> > 
> > The USB dongle that I'm doing tests with is:
> > 
> > 	Bus 004 Device 003: ID 148f:3070 Ralink Technology, Corp.
> > 
> > and is identified by rt2800usb as 3070 flavor:
> > 
> > 	phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1600, rf: 0005, rev: 30700200.
> 
> phy1 -> rt2x00_set_chip: Info - Chipset detected - rt: 1600, rf: 0003, rev: 28600101.
> 
> This doesn't tell me whole lot, 2860 is allegedly PCI, my gizmo is USB.
> (maybe i should poke it with sharp stick... nah, not bored enough)
> 
> USB device ID is 13D3:3247, which is supported by both 2870 and 3070
> drivers, though it's associated with AzureWave instead of IMC Networks
> as reported by lsusb.  In the 3070 section of 2870.h however, I see...
> 
>         {USB_DEVICE(0x13D3,0x3247)}, /* AzureWave */    \
>         {USB_DEVICE(0x13D3,0x3273)}, /* AzureWave 3070*/        \
> 
> ... so _maybe_ it's a 2870.

Seems to be a case here (2870 is USB version of 2860 which would explain
why MAC version is reported to be 2860)..
