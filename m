Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYAPAfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYAPAfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYAPAfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:35:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:44914 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYAPAfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:35:32 -0500
X-ExtLoop1: 1
Subject: Re: Netperf TCP_RR(loopback) 10% regression in
	2.6.24-rc6,	comparing with 2.6.22
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
In-Reply-To: <20080114105307.GA22866@gondor.apana.org.au>
References: <1199871330.3298.132.camel@ymzhang>
	 <1200043854.3265.24.camel@ymzhang>
	 <Pine.LNX.4.64.0801141036400.31652@kivilampi-30.cs.helsinki.fi>
	 <20080114105307.GA22866@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Date: Wed, 16 Jan 2008 08:34:04 +0800
Message-Id: <1200443644.3151.33.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-14 at 21:53 +1100, Herbert Xu wrote:
> On Mon, Jan 14, 2008 at 08:44:40AM +0000, Ilpo Järvinen wrote:
> >
> > > > I tried to use bisect to locate the bad patch between 2.6.22 and 2.6.23-rc1,
> > > > but the bisected kernel wasn't stable and went crazy.
> > 
> > TCP work between that is very much non-existing.
> 
> Make sure you haven't switched between SLAB/SLUB while testing this.
I can make sure. In addition, I tried both SLAB and SLUB and make sure the 
regression is still there if CONFIG_SLAB=y.

Thanks,
-yanmin

