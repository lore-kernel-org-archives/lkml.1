Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZCSNuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZCSNuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbZCSNt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:49:57 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57810 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378AbZCSNt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:49:56 -0400
Date: Thu, 19 Mar 2009 15:49:54 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Lava dual parallel PCI card IRQ problem
In-Reply-To: <Pine.SOC.4.64.0903191525001.26750@math.ut.ee>
Message-ID: <Pine.SOC.4.64.0903191542500.26750@math.ut.ee>
References: <20090318143921.22B5B13A4B0@koiott.tartu-labor>
 <Pine.LNX.4.64.0903191500520.4721@ondatra.tartu-labor>
 <20090319131002.4040b4dd@lxorguk.ukuu.org.uk> <Pine.SOC.4.64.0903191525001.26750@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I remove the second "irq = PARPORT_IRQ_NONE;" it starts to load fine. 
> Will test later with a rela printer attached.

Printer prints without the patch.

The whole system hangs hard when trying to print with the patch applied. 
100% repeatable, and with loglevel 9, nothing appears on the console.

IRQ 11 is shared with many other PCI devices.

-- 
Meelis Roos (mroos@linux.ee)
