Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZFTHYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZFTHYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 03:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZFTHX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 03:23:56 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:40191 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbZFTHXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 03:23:55 -0400
X-IronPort-AV: E=Sophos;i="4.42,258,1243807200"; 
   d="scan'208";a="31620014"
Message-ID: <4A3C8EAE.3030007@inria.fr>
Date: Sat, 20 Jun 2009 09:24:30 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
       Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>	 <87zldjn597.fsf@basil.nowhere.org>	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>	 <20090612103251.GJ25568@one.firstfloor.org> <1245119132.6724.32.camel@lts-notebook>
In-Reply-To: <1245119132.6724.32.camel@lts-notebook>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn wrote:
> My patches don't have per process enablement.  Rather, I chose to use
> per cpuset enablement.  I view cpusets as sort of "numa control groups"
> and thought this was an appropriate level at which to control this sort
> of behavior--analogous to memory_spread_{page|slab}.  That probably
> needs to be discussed more widely, tho'.
>   

Could you explain why you actually want to enable/disable
migrate-on-fault on a cpuset (or process) basis? Why would an
administrator want to disable it? Aren't the existing cpuset memory
restriction abilities enough?

Brice

