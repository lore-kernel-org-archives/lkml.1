Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405Ab0AUVrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0AUVrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130Ab0AUVrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:47:24 -0500
Received: from khc.piap.pl ([195.187.100.11]:51362 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0AUVrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:47:24 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
References: <m33a4nfvva.fsf@intrepid.localdomain>
	<201001141659.19687.bzolnier@gmail.com> <4B57DEE9.8030604@garzik.org>
	<4B57F8D6.6080902@garzik.org> <4B589EFC.6050002@garzik.org>
Date: Thu, 21 Jan 2010 22:47:20 +0100
In-Reply-To: <4B589EFC.6050002@garzik.org> (Jeff Garzik's message of "Thu, 21
	Jan 2010 13:37:48 -0500")
Message-ID: <m3sk9zceqf.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> It is definitely possible to do all 32-bit accesses...  but that
> requires activating and exclusively using the command buffering
> feature, because direct 32-bit access to the taskfile registers will
> result in a 32-bit access to Data rather than the desired effect.

Command buffering? The DS for SIL3512 lists IDEx taskfile registers
for command buffering, but I can't see any explanation there.

BTW I don't know requirements of other platforms, but IXP4xx has only
problems with 8- and 16-bit PCI memory reads. Other ops including
all memory writes, and all "port" I/O are ok.

Unfortunately I can't test any patch ATM, -ENOHW. I might be able to get
access to this hw again, but I don't know at this point.
-- 
Krzysztof Halasa
