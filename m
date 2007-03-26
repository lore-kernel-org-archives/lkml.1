Return-Path: <linux-kernel-owner+w=401wt.eu-S964944AbXCZJzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbXCZJzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965042AbXCZJzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:55:44 -0400
Received: from lazybastard.de ([212.112.238.170]:59874 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbXCZJzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:55:42 -0400
Date: Mon, 26 Mar 2007 11:51:13 +0200
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
Message-ID: <20070326095113.GA22118@lazybastard.org>
References: <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain> <20070325200826.GA19691@lazybastard.org> <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz> <20070325225528.GD19691@lazybastard.org> <1174866394.2866.2.camel@shinybook.infradead.org> <20070326000149.GE19691@lazybastard.org> <1174868485.20505.284.camel@pmac.infradead.org> <20070326010443.GF19691@lazybastard.org> <1174902357.20505.292.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174902357.20505.292.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 March 2007 10:45:57 +0100, David Woodhouse wrote:
> 
> No, on NAND flash it's a limitation of the hardware. The number of write
> cycles you can perform to a given page is limited. Exceed it and the
> contents of that page become undefined due to leakage, until you next
> erase it. 

Are you sure?  Do you have any specs or similar that state this?

So far I have only encountered this limitation by word of mouth.  And
such a myth coming from ECC effects is nothing that would surprise me.

Jörn

-- 
The cheapest, fastest and most reliable components of a computer
system are those that aren't there.
-- Gordon Bell, DEC labratories
