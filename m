Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbZHGHiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbZHGHiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZHGHiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:38:09 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:49244 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756983AbZHGHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:38:08 -0400
X-IronPort-AV: E=Sophos;i="4.43,340,1246831200"; 
   d="scan'208";a="30883782"
Message-ID: <4A7BD9EC.8000801@inria.fr>
Date: Fri, 07 Aug 2009 09:38:20 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
References: <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr> <20090807063226.GA29532@elte.hu>
In-Reply-To: <20090807063226.GA29532@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Ok, there's indeed a flag clash with -s/--sort as you noticed.
>
> -S looks good to me, how about going one step further and changing 
> perf record to use -S/--stat as well, to make the flag consistent 
> across all tools?
>   

Sure, but perf stat already uses -S for --scale :)

Brice

