Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYIPXFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYIPXFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYIPXFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:05:10 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:63885
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYIPXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:05:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocBAEDYz0h8qNU+/2dsb2JhbAAIuh2BZw
X-IronPort-AV: E=Sophos;i="4.32,410,1217779200"; 
   d="scan'208";a="386954495"
Subject: Re: Driver for tightly coupled memory
From: Ben Nizette <bn@niasdigital.com>
To: Alessio Sangalli <alesan@manoweb.com>
Cc: Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48D03811.9070805@manoweb.com>
References: <48CEC71F.3000006@manoweb.com>
	 <20080916093513.GF1916@fluff.org.uk>  <48CFEF3F.5040901@manoweb.com>
	 <1221604022.3598.4.camel@moss.renham>  <48D03811.9070805@manoweb.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 17 Sep 2008 09:04:50 +1000
Message-Id: <1221606290.3598.41.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-16 at 15:49 -0700, Alessio Sangalli wrote:
> Ben Nizette wrote:
> 
> > If a driver needs a quick FIFO it can attempt to get the RAM for said
> > FIFO from the genalloc and fall back to main memory otherwise.  Simple,
> > flexible, easy :-)
> 
> Well, interesting, that is why I asked here before writing code.
> 
> In this case however, do you imply that a device driver will just do all
> the genalloc stuff? In this case it has to know about the TCM details,
> and problems may arise if more than one driver wants to use this
> feature. Or, are you suggesting to write a small TCM driver that will do
> the gen_pool_create() and gen_pool_add() and then export the struct
> gen_pool for use by other drivers that may require it?

Generally the genalloc pool will be set up exactly once, at boot, by the
platform code.  Then yes indeed the pool can be exported for driver use.

	--Ben.
