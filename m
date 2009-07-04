Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZGDIoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZGDIoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 04:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZGDIo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 04:44:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38649 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZGDIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 04:44:28 -0400
Date: Sat, 4 Jul 2009 10:44:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090704084430.GO2041@one.firstfloor.org>
References: <20090703025607.GK5480@parisc-linux.org> <87skhdaaub.fsf@basil.nowhere.org> <20090703185414.GP23611@kernel.dk> <20090703191321.GO5480@parisc-linux.org> <20090703192235.GV23611@kernel.dk> <20090703194557.GQ5480@parisc-linux.org> <20090703195458.GK2041@one.firstfloor.org> <20090703130421.646fe5cb@infradead.org> <20090703233505.GL2041@one.firstfloor.org> <20090703230408.4433ee39@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703230408.4433ee39@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> for networking, especially for incoming data such as new connections,
> that isn't the case.. that's more or less randomly (well hash based)
> distributed.

Ok. Still binding them all to a single CPU all is quite dumb. It
makes MSI-X quite useless and probably even harmful.

We don't default to socket power saving for normal scheduling either, 
but only when you specify a special knob. I don't see why interrupts
should be different.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
