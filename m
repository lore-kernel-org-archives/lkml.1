Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYFWLFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYFWLFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYFWLFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:05:39 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:58610 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYFWLFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:05:38 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [BUGs] must check return value of pci_map_single()/pci_map_page()
Date: Mon, 23 Jun 2008 14:06:22 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200806231406.23027.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

According to Documentation/DMA-mapping.txt one should
check the return value of pci_map_single()/pci_map_page()
using pci_dma_mapping_error(), but many drivers do not.
(I have checked in drivers/net/* for example).

Should we add __must_check in the definitions/declarations 
of these functions/macros "to force" the check?

Best regards

Marin Mitov
