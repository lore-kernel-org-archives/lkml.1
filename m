Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbXCZJqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbXCZJqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXCZJqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:46:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55531 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773AbXCZJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:46:17 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: David Lang <david.lang@digitalinsight.com>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070326010443.GF19691@lazybastard.org>
References: <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
	 <20070325200826.GA19691@lazybastard.org>
	 <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz>
	 <20070325225528.GD19691@lazybastard.org>
	 <1174866394.2866.2.camel@shinybook.infradead.org>
	 <20070326000149.GE19691@lazybastard.org>
	 <1174868485.20505.284.camel@pmac.infradead.org>
	 <20070326010443.GF19691@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Mar 2007 10:45:57 +0100
Message-Id: <1174902357.20505.292.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 03:04 +0200, Jörn Engel wrote:
> That limitation stems from ECC and ECC is done in software.  Currently
> everyone and his dog is doing ECC in chunks of 256 bytes on NAND.  So
> your minimum write size is 256 bytes _if you care about ECC_.  If you
> don't care, you can write single bits on NAND, just as you can on NOR.

No, on NAND flash it's a limitation of the hardware. The number of write
cycles you can perform to a given page is limited. Exceed it and the
contents of that page become undefined due to leakage, until you next
erase it. 

-- 
dwmw2

