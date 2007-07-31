Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbXGaOHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbXGaOHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbXGaOG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:06:58 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54508 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957AbXGaOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:06:57 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: jack@hawkeye.stone.uk.eu.org
Subject: Re: [Patch 08/16] Remove unnecessary kmalloc casts in the parisc drivers.
Date: Tue, 31 Jul 2007 16:06:21 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Matthew Wilcox <matthew@will.cx>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125442.568820000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125442.568820000@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311606.21414.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
> -	a = (unsigned long)kmalloc(sizeof(struct irt_entry) * num_entries + 8, 
GFP_KERNEL);
> +	a = kmalloc(sizeof(struct irt_entry) * num_entries + 8, GFP_KERNEL);

NAK.
Same as in some other patches.
"void *" -> "ulong" is not auto casted and will give you a "warning: 
assignment makes integer from pointer without a cast".

Christian
