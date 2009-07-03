Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZGCTzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZGCTzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZGCTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:54:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51793 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZGCTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:54:55 -0400
Date: Fri, 3 Jul 2009 21:54:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090703195458.GK2041@one.firstfloor.org>
References: <20090703025607.GK5480@parisc-linux.org> <87skhdaaub.fsf@basil.nowhere.org> <20090703185414.GP23611@kernel.dk> <20090703191321.GO5480@parisc-linux.org> <20090703192235.GV23611@kernel.dk> <20090703194557.GQ5480@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703194557.GQ5480@parisc-linux.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would seem to be a fruitful avenue of
> investigation -- whether limiting the cards to a single RX/TX interrupt
> would be advantageous, or whether spreading the eight interrupts out
> over the CPUs would be advantageous.

The kernel should really do the per cpu binding of MSIs by default.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
