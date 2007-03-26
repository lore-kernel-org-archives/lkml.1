Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXCZAGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXCZAGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933176AbXCZAGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:06:11 -0400
Received: from lazybastard.de ([212.112.238.170]:58071 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbXCZAGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:06:09 -0400
Date: Mon, 26 Mar 2007 02:01:52 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Lang <david.lang@digitalinsight.com>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070326000149.GE19691@lazybastard.org>
References: <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain> <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain> <20070325200826.GA19691@lazybastard.org> <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz> <20070325225528.GD19691@lazybastard.org> <1174866394.2866.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174866394.2866.2.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 March 2007 00:46:33 +0100, David Woodhouse wrote:
> On Mon, 2007-03-26 at 00:55 +0200, Jörn Engel wrote:
> > > although, since you can flip bits to 1 without requireing an erase you 
> > [ vice versa.  you can flip bits to 0 without erasing. ]
> 
> And on NAND flash you can't just do it in multiple cycles one bit at a
> time. The 'tally' trick isn't viable there.

You can on NAND.  ECC is done in software.  And for a data structure as
simple as the 'tally', foregoing ECC is not a huge problem - most
bitflips are easily detected and the remaining only cause off-by-a-few
on the erase count.

On NOR with transparent (hardware) ECC you can't.

Jörn

-- 
Homo Sapiens is a goal, not a description.
-- unknown
