Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbXGWV0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbXGWV0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbXGWVZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:25:26 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:36484 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbXGWVZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:25:24 -0400
Message-ID: <46A51CB8.1090400@nortel.com>
Date: Mon, 23 Jul 2007 15:25:12 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Li, Tong N" <tong.n.li@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <p73ir8aubzx.fsf@bingen.suse.de> <1185225015.3593.15.camel@tongli.jf.intel.com>
In-Reply-To: <1185225015.3593.15.camel@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2007 21:25:20.0963 (UTC) FILETIME=[F9385130:01C7CD6F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Li, Tong N wrote:
> On the other hand, if locking does
> become a problem for certain systems/workloads, increasing
> sysctl_base_round_slice can reduce the locking frequency and alleviate
> the problem, at the cost of being relatively less fair across the CPUs. 

If locking does become a problem, it may make sense to switch instead to 
a lockless algorithm of some sort...

Chris
