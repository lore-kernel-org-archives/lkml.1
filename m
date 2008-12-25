Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbYLYKuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbYLYKuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 05:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLYKuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 05:50:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:38430 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbYLYKuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 05:50:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,281,1228118400"; 
   d="scan'208";a="93816879"
Date: Thu, 25 Dec 2008 18:50:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081225105001.GC15733@localhost>
References: <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz> <20081217122726.GA21356@localhost> <20081217123307.GF4480@ics.muni.cz> <20081217124421.GA22317@localhost> <20081217124904.GG4480@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217124904.GG4480@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:49:04PM +0200, Lukas Hejtmanek wrote:
> On Wed, Dec 17, 2008 at 08:44:21PM +0800, Wu Fengguang wrote:
> > So the cache memory shrinks a lot.
> > 
> > Maybe your 'free' command is reporting wrong numbers?
> > Or it's not a quite reproducible problem?
> 
> it depends, I think that 100MB of caches which is not dropped is not quite OK.
> 
> While using the system without reboots for a long time, 'undroppable' amount
> of caches rises until the system is unusable.

Hi Lukas,

Did the undroppable memory keep growing?

If not, we could take it as a feature instead of bug: the memory
mapped pages are being protected from being freed.  It's not a
regression either: the feature was there before 2.6.27.

But sure we change that if it's not the desirable behavior.

Thanks,
Fengguang

