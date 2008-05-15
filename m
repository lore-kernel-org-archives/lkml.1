Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYEOStP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYEOStP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYEOSs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:48:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35809 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYEOSs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:48:58 -0400
Message-ID: <482C8595.5030509@garzik.org>
Date: Thu, 15 May 2008 14:48:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org
CC: Rusty Russell <rusty@rustcorp.com.au>, jeremy@xensource.com,
       Herbert Xu <herbert@gondor.apana.org.au>, Avi Kivity <avi@qumranet.com>
Subject: Virt RNG?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anyone yet written a "hw" RNG module for virt, that reads the host's 
random number pool?

All this talk[1] about IRQF_SAMPLE_RANDOM in network drivers reminds me 
that virt guest instances should be grabbing random numbers from the 
host, especially if the host has a hardware RNG.

	Jeff



[1] lkml&netdev thread: "[PATCH] drivers/net: remove network drivers' 
last few uses of IRQF_SAMPLE_RANDOM"

