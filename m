Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYB1Whq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYB1Whq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYB1Whh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:37:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:34301 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753329AbYB1Whg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:37:36 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+4s9AV5U2444bLx73zSDQ5qt8jIzL56TUcfeNU/t
	yJntAiZ7dNU+3U
Date: Thu, 28 Feb 2008 23:37:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Unknown SATA PIIX PCI device ID 0x29b6
Message-ID: <Pine.LNX.4.64.0802282306190.10087@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

just found out that the eSATA connector on my Intel DQ35JO motherboard 
doesn't work... because it is connected to the controller with product ID 
29b6... And this ID is not yet handled by the driver. Can I have a patch, 
please?:-) I think the correct entry would be

{ 0x8086, 0x29b6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },

just because it also has two ports. Am I right? I would rather not test 
blindly.

BTW, why are these 2920, 2926, and 29b6 IDs not handled by the ahci 
driver? The board-manual does say ICH9...

Thanks
Guennadi
---
Guennadi Liakhovetski
