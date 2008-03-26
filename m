Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbYCZVK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbYCZVK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYCZVKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:10:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49042 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYCZVKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:10:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47EABBA5.8040508@s5r6.in-berlin.de>
Date: Wed, 26 Mar 2008 22:09:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: memory-barriers.txt: cache coherency vs mmio
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject section in memory-barriers.txt says:

"[...] MMIO accesses may, in effect, overtake accesses to cached memory 
that were emitted earlier. A memory barrier isn't sufficient in such a 
case, but rather the cache must be flushed between the cached memory 
write and the MMIO access if the two are in any way dependent."

And the lowly driver programmer immediately asks:
How do I flush the cache?

In particular, do I have to do anyhing between

	coherent_dma_buffer->datum = something;

	writel(YOU_CAN_START_DMA_NOW, register);

Thanks,
-- 
Stefan Richter
-=====-==--- --== ==-=-
http://arcgraph.de/sr/
