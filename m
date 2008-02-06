Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbYBFECr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbYBFECr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 23:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbYBFECi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 23:02:38 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:44744 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYBFECh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 23:02:37 -0500
Message-ID: <47A930EC.9070009@linux.vnet.ibm.com>
Date: Wed, 06 Feb 2008 09:30:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>, Jeff Davis <linux@j-davis.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrea Arcangeli <andrea@qumranet.com>
Subject: Re: [PATCH] badness() dramatically overcounts memory
References: <1202252561.24634.64.camel@dogma.ljc.laika.com> <alpine.DEB.1.00.0802051507460.18347@chino.kir.corp.google.com> <20080206105041.2717.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080206105041.2717.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>>>> The interesting thing is the use of total_vm and not the RSS which is used as
>>>> the basis by the OOM killer. I need to read/understand the code a bit more.
>>> RSS makes more sense to me as well.
>> Andrea Arcangeli has patches pending which change this to the RSS.  
>> Specifically:
>>
>> 	http://marc.info/?l=linux-mm&m=119977937126925
> 
> I agreed with you that RSS is better :)
> 
> 
> 
> but..
> on many node numa, per zone rss is more better..

Do we have a per zone RSS per task? I don't remember seeing it.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
