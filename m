Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYGJNl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYGJNl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYGJNlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:41:50 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:45472 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbYGJNlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:41:49 -0400
Date: Thu, 10 Jul 2008 15:41:46 +0200
From: Martin Lucina <mato@kotelna.sk>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Sustrik <sustrik@fastmq.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org
Subject: Re: Higher than expected disk write(2) latency
Message-ID: <20080710134144.GA31461@dezo.moloch.sk>
References: <20080628121131.GA14181@nodbug.moloch.sk> <20080709222701.8eab4924.akpm@linux-foundation.org> <4875C45C.2010901@fastmq.com> <20080710011417.95532d51.akpm@linux-foundation.org> <1215696541.24425.214.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215696541.24425.214.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chris.mason@oracle.com said:
> Is NCQ enabled on the drive?  The basic way to fix this is to have
> multiple requests in flight, which isn't going to happen on sata with
> the cache off and with ncq off.

ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: Hitachi HDS721616PLA380, P22OAB3A, max UDMA/133
ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133

I'm assuming the above indicates NCQ is enabled.

We'll try running the tests tomorrow with different i/o schedulers and
report back.

-mato
