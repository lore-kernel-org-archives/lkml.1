Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXGNTCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXGNTCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760199AbXGNTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:01:58 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:19239 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759758AbXGNTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=IymSNZsKPrvdoD5MdSTEzm5miO6mtMG8Qs3HC1YzqLAftxI1UGDYqVe3Unoj5tvYFUQI7fsxdMtO8TecHk7jooNs/QBliNEpDEmT7XTryv6B3Kpd87RXKEztJvewiW1cwOQ650LTuuHzJ/YhTXpyUUK8yW5VocxXAhKJ75ZQ5cA=
Message-ID: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
Date: Sat, 14 Jul 2007 15:01:56 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org
Subject: Geode GX framebuffer driver: Arcom vs. AMD
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 930055c6b1eb7dac
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason why the GPL framebuffer driver for the GX/GX1/LX
directly from AMD is not integrated into the kernel and only a custom
driver for only the GX/GX1 written by Arcom exists?
(drivers/video/geode/*)

If you have an LX, the Arcom driver won't work and it is difficult to
use AMD's patch for 2.6.11 with a more recent kernel because the
drivers/video/geode directory has filename conflicts with files in the
patch.

If there are no issues preventing its inclusion, would updated patches
be accepted to switch to AMD's framebuffer driver? The AMD patches
would need to be combined to support all three platforms in the driver
dir, all sitting on top of the Cimarron HAL installed in lib/cimarron.

The entire AMD LX patch for 2.6.11 is here:
http://www.amd.com/files/connectivitysolutions/geode/geode_lx/Patches_Linux2.6.11_Common_02.03.0100.patch

The relevant parts are:
drivers/video/geode/*
lib/cimarron/*

Thanks, -Andrew
