Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbZGCUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbZGCUDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZGCUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:03:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:39150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbZGCUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:03:10 -0400
Date: Fri, 3 Jul 2009 13:04:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090703130421.646fe5cb@infradead.org>
In-Reply-To: <20090703195458.GK2041@one.firstfloor.org>
References: <20090703025607.GK5480@parisc-linux.org>
	<87skhdaaub.fsf@basil.nowhere.org>
	<20090703185414.GP23611@kernel.dk>
	<20090703191321.GO5480@parisc-linux.org>
	<20090703192235.GV23611@kernel.dk>
	<20090703194557.GQ5480@parisc-linux.org>
	<20090703195458.GK2041@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 21:54:58 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > That would seem to be a fruitful avenue of
> > investigation -- whether limiting the cards to a single RX/TX
> > interrupt would be advantageous, or whether spreading the eight
> > interrupts out over the CPUs would be advantageous.
> 
> The kernel should really do the per cpu binding of MSIs by default.

... so that you can't do power management on a per socket basis?
hardly a good idea.

just need to use a new enough irqbalance and it will spread out the
interrupts unless your load is low enough to go into low power mode.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
