Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbZGDGEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbZGDGEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 02:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZGDGE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 02:04:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:60852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZGDGE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 02:04:26 -0400
Date: Fri, 3 Jul 2009 23:04:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090703230408.4433ee39@infradead.org>
In-Reply-To: <20090703233505.GL2041@one.firstfloor.org>
References: <20090703025607.GK5480@parisc-linux.org>
	<87skhdaaub.fsf@basil.nowhere.org>
	<20090703185414.GP23611@kernel.dk>
	<20090703191321.GO5480@parisc-linux.org>
	<20090703192235.GV23611@kernel.dk>
	<20090703194557.GQ5480@parisc-linux.org>
	<20090703195458.GK2041@one.firstfloor.org>
	<20090703130421.646fe5cb@infradead.org>
	<20090703233505.GL2041@one.firstfloor.org>
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

On Sat, 4 Jul 2009 01:35:05 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > ... so that you can't do power management on a per socket basis?
> > hardly a good idea.
> 
> Interrupts should only happen when the socket did spent time
> submitting the work for them. Typically on drivers I'm familiar with
> the return MSI is tied to the CPU that did submit the work item

for networking, especially for incoming data such as new connections,
that isn't the case.. that's more or less randomly (well hash based)
distributed.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
