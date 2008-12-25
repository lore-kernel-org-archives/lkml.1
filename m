Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbYLYLSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbYLYLSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 06:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLYLSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 06:18:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:51987 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYLYLSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 06:18:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,281,1228118400"; 
   d="scan'208";a="93821386"
Date: Thu, 25 Dec 2008 19:18:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081225111802.GA16080@localhost>
References: <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz> <20081217122726.GA21356@localhost> <20081217123307.GF4480@ics.muni.cz> <20081217124421.GA22317@localhost> <20081217124904.GG4480@ics.muni.cz> <20081225105001.GC15733@localhost> <20081225105850.GF4414@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225105850.GF4414@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 12:58:50PM +0200, Lukas Hejtmanek wrote:
> On Thu, Dec 25, 2008 at 06:50:01PM +0800, Wu Fengguang wrote:
> > Did the undroppable memory keep growing?
> 
> unfotunatley not any more.
>  
> > If not, we could take it as a feature instead of bug: the memory
> > mapped pages are being protected from being freed.  It's not a
> > regression either: the feature was there before 2.6.27.
> > 
> > But sure we change that if it's not the desirable behavior.
> 
> so I think the issue can be closed for now. I will reopen if I discover
> something.

OK, thank you.

Fengguang
