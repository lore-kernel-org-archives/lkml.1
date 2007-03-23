Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbXCWOMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbXCWOMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXCWOMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:12:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35368 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXCWOMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:12:16 -0400
Date: Fri, 23 Mar 2007 15:12:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;)
Message-ID: <20070323141210.GA20548@one.firstfloor.org>
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com> <4602FF57.7030001@cosmosbay.com> <20070322224045.GA3200@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322224045.GA3200@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But that is based on compile time option, isn't it? Perhaps I need
> to use some other mechanism to find out the platform is not NUMA capable..

We can probably make it runtime on x86. That will be needed sooner or 
later for correct NUMA hotplug support anyways.

-Andi
