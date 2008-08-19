Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYHSSUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYHSSUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYHSST6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:19:58 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:7322 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYHSST5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BeJ+JzyN46NsESL8aMOsNvoGrLaTRY1fElPLDO77K+YETvv4yhl1aFJzUn8mm0VI3L
         34rHaG7hMR/ngDVFacqCV1AsubP91YDQA8x8EvCdK/dMSCrVyrPKctY95i8vlN8dkXu5
         yKnIZlwU/MneoYh2HsWk7BZRNGuuxajsttQDo=
Message-ID: <81b0412b0808191119y3fe473bbi43ca5524ff4d20ac@mail.gmail.com>
Date: Tue, 19 Aug 2008 20:19:56 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: rt2500pci: rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200808192003.45072.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080819173524.GA4708@steel.home>
	 <200808192003.45072.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/19 Ivo van Doorn <ivdoorn@gmail.com>:
>> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
>> produces a lot of this messages in log (slowdown quite noticable):
>>
>>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
>>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.
>>     last message repeated 40 times
>>     kernel: phy0 -> rt2500pci_rf_write: Error - RFCSR register busy. Write failed.
>>     last message repeated 7 times
>>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.
>
> This is a bad sign, the slowdown is expected since the driver is continuously looping
> waiting for the registers to become available. Did this PCI card work in the past, and
> if so with what driver?

It surely did, but I honestly don't remember what with. I'll try to bisect.

> Does this card work on another PC, or does the windows or legacy driver work with
> this card?

No Windows here, but see below

> (Yes, all suggestions above imply suspicion about the hardware itself rather then the driver)

Well, it used to crash some industrial board (I believe it was some
Boser, HS-series, with
this card in a PCI slot of its backplane). So you're not alone in your
suspicions (OTOH,
that board was known to misbehave itself).

I have no particular need for that card, so if someone wants it for
testing I gladly
part with it (and if you happen be in Germany, I'll just mail it).
