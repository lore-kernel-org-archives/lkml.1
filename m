Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXH1M4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXH1M4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXH1M4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:56:08 -0400
Received: from mail.cargoscan.com ([213.145.173.179]:62666 "EHLO quark"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbXH1M4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:56:07 -0400
Message-ID: <46CD75F3.6030707@rutger.no>
Date: Thu, 23 Aug 2007 13:56:35 +0200
From: "Espen M. Rutger" <espen@rutger.no>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ide.c and compactFlash
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I got problems with the IDE code which causes the kernel to freez after 
printing out:

hda: status timeout: status=0xd0 { Busy }

kernel used: 2.4.18 crosscompiled with Montavista tools (ppc_82xx-gcc 
(GCC) 3.2.1 20020930 (MontaVista))

The ide interface chip is a PD6729 configured to ATA mode.

CompactFlash cards: winsys 1GB industrial grade and simpleTech 1GB 
industrial grade.

I beleive this is a timing issue and have tried to increase a udelay () 
to 2 microseconds (instead of 1 microsecond) in the ide_wait_stat() 
function - it took longer time to freez, but it still freezes...


Any clues?

Regards
Espen M. Rutger

