Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYCaAuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYCaAuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 20:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYCaAuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 20:50:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:32353 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYCaAuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 20:50:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,580,1199692800"; 
   d="scan'208";a="363098727"
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct
	setup_data
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440803300115w6f3cc08cha72d3dc20bc4ec8e@mail.gmail.com>
References: <1206672584.13404.25.camel@caritas-dev.intel.com>
	 <86802c440803300115w6f3cc08cha72d3dc20bc4ec8e@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 31 Mar 2008 08:52:48 +0800
Message-Id: <1206924768.21451.3.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Mar 2008 00:49:36.0888 (UTC) FILETIME=[18014F80:01C892C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-30 at 01:15 -0700, Yinghai Lu wrote:
[...]
> current reserve_early will have limitation with 20 entries.
> 
> /*
>  * Early reserved memory areas.
>  */
> 
> #define MAX_EARLY_RES 20
> 
> or we need to make reserve_early a little bit smart, so it could merge
> continuous region...
> and then your free_early need to be updated too.

It is planned that the reserve_early code be replaced by e820 based
memory reservation code. So I think we can stay with current
implementation and wait for the new infrastructure.

Best Regards,
Huang Ying

