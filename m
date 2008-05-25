Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYEYEsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYEYEsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYEYEsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:48:32 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:51123 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYEYEsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:48:31 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: DECLARE_PCI_UNMAP_{ADDR,LEN} question
Date: Sun, 25 May 2008 07:48:38 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200805250748.38163.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In Documentation/DMA-mapping.txt is written:

NOTE: DO NOT put a semicolon at the end of the 
DECLARE_PCI_UNMAP_{ADDR,LEN}() macro.

While the output of 
grep DECLARE_PCI_UNMAP_  drivers/net/* 
contains lines with and without semicolon:
drivers/net/acenic.h:   DECLARE_PCI_UNMAP_ADDR(mapping)
drivers/net/acenic.h:   DECLARE_PCI_UNMAP_ADDR(mapping)
drivers/net/acenic.h:   DECLARE_PCI_UNMAP_LEN(maplen)
drivers/net/bnx2.h:     DECLARE_PCI_UNMAP_ADDR(mapping)
drivers/net/bnx2.h:     DECLARE_PCI_UNMAP_ADDR(mapping)
drivers/net/bnx2x.h:    DECLARE_PCI_UNMAP_ADDR(mapping)
drivers/net/qla3xxx.h:   DECLARE_PCI_UNMAP_ADDR(mapaddr);
drivers/net/qla3xxx.h:   DECLARE_PCI_UNMAP_LEN(maplen);
drivers/net/qla3xxx.h:   DECLARE_PCI_UNMAP_ADDR(mapaddr);
drivers/net/qla3xxx.h:   DECLARE_PCI_UNMAP_LEN(maplen);
drivers/net/skge.h:     DECLARE_PCI_UNMAP_ADDR(mapaddr);
drivers/net/skge.h:     DECLARE_PCI_UNMAP_LEN(maplen);
drivers/net/sky2.h:     DECLARE_PCI_UNMAP_ADDR(mapaddr);
drivers/net/sky2.h:     DECLARE_PCI_UNMAP_ADDR(maplen);
drivers/net/sky2.h:     DECLARE_PCI_UNMAP_ADDR(data_size);
drivers/net/tg3.h:      DECLARE_PCI_UNMAP_ADDR(mapping)
drivers/net/tg3.h:      DECLARE_PCI_UNMAP_ADDR(mapping)

My question is: 
Why one should NOT put semicolon at the end of the macro?
If it is _really_ important, should it be removed/patched?

Thank you for your answers.

Regards

Marin Mitov

