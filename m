Return-Path: <linux-kernel-owner+w=401wt.eu-S1750807AbXBWDdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750807AbXBWDdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXBWDdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:33:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbXBWDdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:33:32 -0500
Message-ID: <45DE6080.6030904@redhat.com>
Date: Thu, 22 Feb 2007 22:33:20 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: yunfeng zhang <zyf.zeroos@gmail.com>
CC: linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       linux-mm@kvack.org
Subject: Re: [PATCH 2.6.20-rc5 1/1] MM: enhance Linux swap subsystem
References: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com>	 <4df04b840701222021w5e1aaab2if2ba7fc38d06d64b@mail.gmail.com>	 <4df04b840701222108o6992933bied5fff8a525413@mail.gmail.com>	 <Pine.LNX.4.64.0701242015090.1770@blonde.wat.veritas.com>	 <4df04b840701301852i41687edfl1462c4ca3344431c@mail.gmail.com>	 <Pine.LNX.4.64.0701312022340.26857@blonde.wat.veritas.com>	 <4df04b840702122152o64b2d59cy53afcd43bb24cb7a@mail.gmail.com>	 <4df04b840702200106q670ff944k118d218fed17b884@mail.gmail.com>	 <4df04b840702211758t1906083x78fb53b6283349ca@mail.gmail.com>	 <45DCFDBE.50209@redhat.com> <4df04b840702221831x76626de1rfa70cb653b12f495@mail.gmail.com>
In-Reply-To: <4df04b840702221831x76626de1rfa70cb653b12f495@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yunfeng zhang wrote:
> Performance improvement should occur when private pages of multiple 
> processes are messed up,

Ummm, yes.  Linux used to do this, but doing virtual scans
just does not scale when a system has a really large amount
of memory, a large number of processes and multiple zones.

We've seen it fall apart with as little as 8GB of RAM.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
