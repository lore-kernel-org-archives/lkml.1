Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbXFZUAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbXFZUAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXFZUAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:00:09 -0400
Received: from gw.goop.org ([64.81.55.164]:48646 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbXFZUAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:00:08 -0400
Message-ID: <46817016.7090400@goop.org>
Date: Tue, 26 Jun 2007 15:59:18 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dma_mapping_ops for i386
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at adding dom0 support to the pv-ops kernel.  One of the 
obvious things we need is to support real device drivers, and the 
associated p->m translations for devices.

I'm thinking the cleanest thing to do is make x86-64's dma-mapping.h 
with its dma_mapping_ops common to i386 and x86-64, so we can hook the 
Xen translations in there.  Presumably we'll need to do this anyway to 
support VTd for 32-bit (but I don't know if that's a reasonable thing to 
do anyway).

What do you think?

    J
