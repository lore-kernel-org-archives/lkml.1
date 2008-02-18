Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYBRFAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYBRFAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYBRFAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:00:38 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:35572 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750857AbYBRFAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:00:23 -0500
Message-ID: <47B91008.8050505@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2008 10:26:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: vatsa@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.25-rc1: volanoMark 45% regression
References: <1202895028.3027.27.camel@ymzhang> <47B2BC2C.80100@linux.vnet.ibm.com> <20080213120708.GA16231@linux.vnet.ibm.com> <1202974901.3027.58.camel@ymzhang> <1203067505.3027.178.camel@ymzhang>
In-Reply-To: <1203067505.3027.178.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
>>
>>>  Did you have
>>> CONFIG_FAIR_USER_SCHED enabled in both cases?
>> Yes.
>>
>> CONFIG_FAIR_GROUP_SCHED=y
>> CONFIG_FAIR_USER_SCHED=y
>>

Interesting that you have CONFIG_FAIR_USER_SCHED. Do you have any other users on
the system (are they running anything at the time of the benchmark)? Could you
turn off CONFIG_FAIR_USER_SCHED  and turn on CONFIG_FAIR_GROUP_SCHED. I am going
to run some tests with 2.6.25-rc2 and Volanomark and see how that goes.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
