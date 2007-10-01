Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXJAKBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXJAKBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXJAKBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:01:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:49600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbXJAKBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:01:25 -0400
To: "Denys" <nuclearcat@nuclearcat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
References: <20070930144443.M52139@visp.net.lb>
	<46FFE17C.9020202@cosmosbay.com>
	<200709301425.37564.nickpiggin@yahoo.com.au>
	<20070930220452.M25621@nuclearcat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Oct 2007 12:01:24 +0200
In-Reply-To: <20070930220452.M25621@nuclearcat.com>
Message-ID: <p73myv36tmz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Denys" <nuclearcat@nuclearcat.com> writes:

> by mistake i will miss a point (it can detect bug easily, IF softirq in 
> mpstat 1 will jump up to 30+%. On 2.6.21 it is always staying +-10%, on 
> "buggy" version it jumps up to 100%. Now cause less load at night up to 30-
> 50%, so on hardware it is not very noticeable (thats why maybe not much 
> feedbacks), i am trying to utilise hardware maximum as possible - so i feel 
> regressions much more.

You could use oprofile to find where the CPU time is spent

-Andi
