Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXFDMnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXFDMnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXFDMnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:43:10 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:22264 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXFDMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:43:07 -0400
In-Reply-To: <20070531134118.GA30501@infradead.org>
Subject: Re: [PATCH 2/2] ehea: Receive SKB Aggregation
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan-Bernd Themann <themann@de.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       ossthema@linux.vnet.ibm.com, Thomas Q Klein <tklein@de.ibm.com>,
       tklein@linux.ibm.com
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF7723C01B.9DD0E9DC-ONC12572F0.0040CA22-C12572F0.0042AC08@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Mon, 4 Jun 2007 14:09:47 +0200
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 04/06/2007 14:43:03
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig wrote on 31.05.2007 15:41:18:

> I'm still very unhappy with having all this in various drivers.  There's
> a lot of code that can be turned into generic library functions, and even
> more code that could be made generic with some amount of refactoring.

Yes, we'd also prefer to use a generic function, but we first would want to
get
some "real world" experience how our driver behaves with LRO to be even
able to
define requirements for such a generic function. A lot of this is tied into
pathlengths,
caching, and why does that help compared to a different TCP receive side
processing?
In a perfect world we shouldn't see a diffference if this is enabled or
not,
but measurements indicate something completely different at 10gbit.

Gruss / Regards
Christoph Raisch


