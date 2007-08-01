Return-Path: <linux-kernel-owner+w=401wt.eu-S1764118AbXHAARY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764118AbXHAARY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbXHAARD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:17:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54230 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191AbXHAAQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:54 -0400
Date: Wed, 1 Aug 2007 09:17:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       <Zoltan.Menyhart@bull.net>, "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [3/4] add montecito
 brand name
Message-Id: <20070801091743.1ca10245.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A020E3B04@scsmsx411.amr.corp.intel.com>
References: <20070731114007.b3c62cd3.kamezawa.hiroyu@jp.fujitsu.com>
	<617E1C2C70743745A92448908E030B2A020E3B04@scsmsx411.amr.corp.intel.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 09:39:58 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> +		} else if (family == 0x20)
> +			memcpy(brand, "Montecito", 10);
> 
> NAK.
> 
> We don't really have names for the different cpu families. "Montecito"
> is definitely not the right string to apply here (Montvale will also
> have family == 0x20).  The old McKinley/Madison strings are intended
> to provide some information for old processors where PAL did not
> support PAL_BRAND_INFO.  All new cpus (from Montecito onward) will
> support this PAL call, so there should be no need to add more code to
> make names out of [family,model] tuples.
> 

Ok, please ignore patch [3/4] and [4/4]. 

-Kame

