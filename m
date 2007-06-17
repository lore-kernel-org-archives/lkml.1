Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbXFQB1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbXFQB1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 21:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXFQB1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 21:27:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34424 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXFQB1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 21:27:30 -0400
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
	Blocksize support
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20070614143248.736312f8.akpm@linux-foundation.org>
References: <20070614193839.878721298@sgi.com>
	 <20070614130645.cabdff1b.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	 <20070614143248.736312f8.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 16 Jun 2007 18:25:00 -0700
Message-Id: <1182043500.2743.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> You: conceptully-new add-on which benefits 0.25% of the user base, provided
> they select the right config options and filesystem.
> 
> Me: simpler enhancement which benefits 100% of the user base (ie: includes
> 4k blocksize, 4k pagesize) and which also fixes your performance problem
> with that HBA.

note that at least 2.6 is doing this "sort of", better than 2.4 at
least. (30% hitrate or something like that).

In addition, systems with an IOMMU (many really large systems have that,
as well as several x86 ones, with more and more of that in the future),
this is a moot point since the IOMMU will just linearize for the device.


