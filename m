Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXCZAVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXCZAVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933208AbXCZAVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:21:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbXCZAVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:21:32 -0400
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
In-Reply-To: <20070326000149.GE19691@lazybastard.org>
References: <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
	 <20070325200826.GA19691@lazybastard.org>
	 <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz>
	 <20070325225528.GD19691@lazybastard.org>
	 <1174866394.2866.2.camel@shinybook.infradead.org>
	 <20070326000149.GE19691@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Mar 2007 01:21:25 +0100
Message-Id: <1174868485.20505.284.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 02:01 +0200, Jörn Engel wrote:
> You can on NAND.  ECC is done in software.  And for a data structure as
> simple as the 'tally', foregoing ECC is not a huge problem - most
> bitflips are easily detected and the remaining only cause off-by-a-few
> on the erase count. 

You're only allowed a limited number of write cycles to each page
though. So you can't just clear the bits in a 2112-byte page one at a
time; typically when you clear the fifth bit, the contents of the whole
page become undefined until the next erase cycle.

-- 
dwmw2

