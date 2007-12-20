Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbXLTRko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbXLTRko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbXLTRkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:40:20 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33772 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbXLTRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:40:18 -0500
Message-ID: <476AA8EE.1000206@linux.vnet.ibm.com>
Date: Thu, 20 Dec 2007 23:09:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <haveblue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in free_hot_cold_page
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop> <1198084473.15321.48.camel@localhost> <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com> <1198158702.6821.8.camel@twins> <Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com> <1198160410.6821.13.camel@twins> <476A972F.6050904@linux.vnet.ibm.com> <20071220091215.a87d2588.akpm@linux-foundation.org> <Pine.LNX.4.64.0712201715160.16967@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0712201715160.16967@blonde.wat.veritas.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 20 Dec 2007, Andrew Morton wrote:
>> On Thu, 20 Dec 2007 21:54:15 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>> I was going to say the same thing, page_get_page_cgroup() does not hold
>>> any references. May be _get_ in the name is confusing.
>> It is a bit unconventional.  page_cgroup()?
> 
> Seems ideal to me
> (though there is some argument for page_page_cgroup(), weird as it is).
> 
> Hugh

Sounds good to me as well, except that it sounds like a constructor :-)
I'll try and make the changes and submit a patch. I am in the middle of
losing control_type now (based on Hugh's comments)

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
