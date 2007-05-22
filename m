Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXEVJYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXEVJYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbXEVJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:24:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbXEVJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:24:05 -0400
Date: Tue, 22 May 2007 11:23:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Andi Kleen <andi@firstfloor.org>, "Brown, Len" <len.brown@intel.com>,
       tglx@linutronix.de, mingo@elte.hu, "Zhu, Yi" <yi.zhu@intel.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org, trenn@suse.de
Subject: Re: Increased ipw2200 power usage with dynticks
Message-ID: <20070522092359.GA13298@one.firstfloor.org>
References: <20070521074938.GA15678@atjola.homenet> <653FFBB4508B9042B5D43DC9E18836F5EA4D36@scsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5EA4D36@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Nice to hear that cpuidle-menu governor gets 13.9W :-).
> Powertop will need some changes to go with cpuidle, but that should be simple.
> 
> We need some more testing for cpuidle before it gets into git.
> Len: Looks like cpuidle got dropped out of mm again. Can you merge it back it please.

It probably needs some good review. I'm still not completely convinced
its full generity is needed for example. e.g. how would different governours
look like?  Wouldn't it make more sense to concentrate on a single
policy ?

-Andi
