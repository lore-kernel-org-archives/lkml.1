Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYIBJ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYIBJ6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYIBJ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:58:39 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41486 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYIBJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:58:38 -0400
Message-ID: <48BD0E4A.5040502@linux.vnet.ibm.com>
Date: Tue, 02 Sep 2008 15:28:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <200809011656.45190.nickpiggin@yahoo.com.au> <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <200809011743.42658.nickpiggin@yahoo.com.au> <48BD0641.4040705@linux.vnet.ibm.com> <20080902190256.1375f593.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080902190256.1375f593.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 02 Sep 2008 14:54:17 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Nick Piggin wrote:
>>> That could be a reasonable solution.  Balbir has other concerns about
>>> this... so I think it is OK to try the radix tree approach first.
>> Thanks, Nick!
>>
>> Kamezawa-San, I would like to integrate the radix tree patches after review and
>> some more testing then integrate your patchset on top of it. Do you have any
>> objections/concerns with the suggested approach?
>>
> please show performance number first.

Yes, that is why said some more testing. I am running lmbench and kernbench on
it and some other tests, I'll get back with numbers.

-- 
	Balbir
