Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYAaOvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYAaOvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYAaOvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:51:04 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:13896 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYAaOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:51:01 -0500
Date: Thu, 31 Jan 2008 15:50:58 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, NeilBrown <neilb@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: crypto/async_tx/* doesn't build on s390
Message-ID: <20080131145058.GA6789@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following:

crypto/built-in.o: In function `do_async_xor':
async_xor.c:49: undefined reference to `dma_map_page'
async_xor.c:56: undefined reference to `dma_map_page'

This is mainly because s390 doesn't support DMA at all,
but these files get selected via MD_RAID456 anyway.

Any idea how to fix this?
