Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZH1Mua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZH1Mua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZH1Mu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:50:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZH1Mu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:50:29 -0400
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
 cpumask on multi-node processors
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090828120332.GH13576@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins>
	 <20090825093101.GJ20811@alberich.amd.com>
	 <1251194143.7538.1128.camel@twins>
	 <20090827152551.GE13576@alberich.amd.com> <1251455984.17617.5.camel@laptop>
	 <20090828120332.GH13576@alberich.amd.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 14:50:27 +0200
Message-Id: <1251463827.17617.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 14:03 +0200, Andreas Herrmann wrote:
> 
> > the opteron I have seems to be two
> > single cores
> 
> Really? I am not aware of such a thing.
> 
> Can you check how many sets of northbridge functions do you have?  If
> you would have two dies in one package then you should see one set of
> PCI functions at bus 0 device 24 and a second set of PCI functions at
> bus 0 device 25, e.g.
> 
>   # lspci -d 1022:
>   ...
>   00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h
>           [Opteron, Athlon64, Sempron] HyperTransport Configuration [1022:1200]
>   ...
>   00:19.0 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h
>           [Opteron, Athlon64, Sempron] HyperTransport Configuration [1022:1200]
>   ... 

Doesn't appear to be the case, maybe I mis-remembered the various masks
for that machine.

Oh well ;-)

