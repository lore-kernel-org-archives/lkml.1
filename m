Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbYEYFns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbYEYFns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 01:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYEYFnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 01:43:37 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:51157 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYEYFnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 01:43:37 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: pci_set_consistent_dma_mask() question
Date: Sun, 25 May 2008 08:43:47 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805250843.47179.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In the file: Documentation/DMA-mapping.txt is written:

pci_set_consistent_dma_mask() will always be able to set the same or a
smaller mask as pci_set_dma_mask(). However for the rare case that a
device driver only uses consistent allocations, one would have to
check the return value from pci_set_consistent_dma_mask().

grep-ing drivers/net/* shows that in many drivers 
the return value of pci_set_consistent_dma_mask() is checked
in the path where pci_set_dma_mask() was already successfull.
Sure, this is during driver's initiallysation, so it is not time critical.

My question: Is it worth to remove the unnecessary checks?
I could prepare patches if you find it worthfull.

Best regards.

Marin Mitov
