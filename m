Return-Path: <linux-kernel-owner+w=401wt.eu-S935049AbXK3PWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049AbXK3PWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760953AbXK3PWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:22:15 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:12324 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbXK3PWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:to:subject:cc:message-id:date:from;
        b=fjTofRPoZiUindtb7TRG48cjwedGkkZSB71DK4JCBMOYYcZ3JAynTGApYsRI45eN6bJX4ksOfrF7pheafnUJFN82sJqZjYRBRiqTzrk9kJy495mtS48dmo4FJe69VrVQ11txSDKCfzemCONgoWEYoild3rtwZWhFLVPeGguFYfU=
To: dsterba@suse.cz, jeff@garzik.org
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
Cc: akpm@linux-foundation.org, benm@symmetric.co.nz, jkosina@suse.cz,
       jslaby@suse.cz, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, stephen@symmetric.co.nz
Message-Id: <20071130152019.C689B19E20E@silentrunning.homelinux.org>
Date: Fri, 30 Nov 2007 15:20:19 +0000 (GMT)
From: msar2020@gmail.com (Michael Robb)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>If the -main- purpose of the hardware is wireless, it should go in via
>John Linville, wireless maintainer...

These GPRS cards are basically wireless modems which accept a Hayes command
set (AT+????, etc...), can send and receive SMS messages, as well as 
support WAP and PPP internet surfing.

Hayes commands allow for measuring local signal strength (AT+CSQ), reading
and writing SMS messages (AT+CMGF, AT+CMGW, AT+CNMI) etc...

So, it is somewhere between a serial driver and a wireless driver.

- Michael
