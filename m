Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbZGDCfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbZGDCfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZGDCe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:34:59 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:51333 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbZGDCe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=knBTz4e4aj5V2ZZ+RUFlIBfOOil9Auaqq0ZlkWFqD6US0v/uqGCUcc3m7z658Lyad2
         frc0DNueKv8G4K+p4UOuGD9O5V0nVpYsHATKA/USy0upDz9b8XWqkwVjE2RwqpHtqjvK
         n7Ay6nw+8TdvkD2YweSnDroLcJ+5+UnZC4cH4=
From: tom.leiming@gmail.com
To: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/3] dma-mapping:remove CONFIG_HAVE_DMA_ATTRS
Date: Sat,  4 Jul 2009 10:34:52 +0800
Message-Id: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets  enable CONFIG_HAVE_DMA_ATTRS always, so remove
it in dma-mapping and Kconfig of X86 and IA64 arch, based on
the following ideas:

1,Currently asm-generic/dma-mapping-common.h has provided dma_map_*_attrs()
and dma_unmap_*_attrs(), and more ARCHs will move to asm-generic/dma-mapping-common.h;

2,Disabling CONFIG_HAVE_DMA_ATTRS may lead to a compile failure;

3,X86 and IA64 has taken asm-generic/dma-mapping-common.h and always enabled the
option now;

4,If CONFIG_HAVE_DMA_ATTRS is enabled, dma_set/get_attr support the passed attrs
is NULL.


