Return-Path: <linux-kernel-owner+w=401wt.eu-S1161505AbXEDSyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161505AbXEDSyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161875AbXEDSyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:54:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54151 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161653AbXEDSyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:54:09 -0400
Message-ID: <463B815E.8010806@cs.helsinki.fi>
Date: Fri, 04 May 2007 21:54:22 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [PATCH 08/40] mm: kmem_cache_objsize
References: <20070504102651.923946304@chello.nl>  <20070504103157.215424767@chello.nl>  <Pine.LNX.4.64.0705040932200.22033@schroedinger.engr.sgi.com>  <1178301545.24217.56.camel@twins>  <Pine.LNX.4.64.0705041104110.23539@schroedinger.engr.sgi.com>  <1178302904.2767.6.camel@lappy>  <Pine.LNX.4.64.0705041128270.24283@schroedinger.engr.sgi.com> <1178303538.2767.9.camel@lappy> <463B7F63.8070508@cs.helsinki.fi> <Pine.LNX.4.64.0705041147000.24625@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705041147000.24625@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 4 May 2007, Pekka Enberg wrote:
> 
>> Again, slab has no way of actually estimating how many pages you need for a
>> given number of objects. So we end up calculating some upper bound which
>> doesn't belong in mm/slab.c. I am perfectly okay with:
> 
> It can give a worst case number and that is what he wants.

Sure. But he can calculate that elsewhere instead of bringing it in 
mm/slab.c where it's no use for anyone else...


