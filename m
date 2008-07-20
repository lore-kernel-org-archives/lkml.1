Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbYGTSgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbYGTSgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 14:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYGTSgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 14:36:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33703 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYGTSgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 14:36:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <488385A7.4010509@s5r6.in-berlin.de>
Date: Sun, 20 Jul 2008 20:36:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080719 SeaMonkey/1.1.10
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: dma_alloc_coherent() on PPC32: physical addresses above 2G possible?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have to implement a workaround for a PCI device which gets into 
trouble if descriptors are located at 32bit addresses, while 31bit 
addresses are fine.  I would like to avoid this workaround on machines 
on which dma_alloc_coherent() won't ever go at memory above 2 GB.

Is defined(CONFIG_PPC32) a safe test for this?  I'm under the impression 
that defined(CONFIG_X86_32) is safe.

Are there any other means to detect when the workaround can be omitted, 
at compile time or at runtime?

PS:  I don't want to set the DMA mask of this device to DMA_31BIT_MASK 
because that would be detrimental to other functions of the device. It's 
a TI TSB43AB22A FireWire controller.
-- 
Stefan Richter
-=====-==--- -=== =-=--
http://arcgraph.de/sr/
