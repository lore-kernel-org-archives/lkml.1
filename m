Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXL2T2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXL2T2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 14:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXL2T15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 14:27:57 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:36453 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXL2T15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:27:57 -0500
X-IronPort-AV: E=Sophos;i="4.24,221,1196658000"; 
   d="scan'208";a="59175110"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [2.6.24 patch] restore blackfin HARDWARE_PM support
Date: Sat, 29 Dec 2007 14:28:50 -0500
User-Agent: KMail/1.9.5
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
References: <20071228185643.GB4738@stusta.de> <200712290114.46694.rgetz@blackfin.uclinux.org> <20071229062326.GA16853@Krystal>
In-Reply-To: <20071229062326.GA16853@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712291428.50359.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 29 Dec 2007 19:27:55.0290 (UTC) FILETIME=[E95A2FA0:01C84A50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 29 Dec 2007 01:23, Mathieu Desnoyers pondered:
> Ok, and do we really need to make HARDWARE_PM a tristate ? I see that
> part of it must be compiled into the kernel in core .S files. Does it
> really make sense for it to be a module ?

I don't think so.

> Also, op_model_bf533.c sits in the arch/blackfin/oprofile directory,
> (built if HARDWARE_PM is y or m) but depends on PROFILING, not OPROFILE.
> Is HARDWARE_PM useful at all without OPROFILE ?

There was an out of tree patch that was floating around that gave people a sys 
or proc interface to the hardware registers - since oprofile doesn't work 
that well on a bash-less system.

I don't think I will have time to look at the patch over the weekend, but will 
do after Jan 1.

-Robin
