Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYAUGPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYAUGPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 01:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYAUGPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 01:15:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57664 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYAUGPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:15:00 -0500
Message-ID: <4794384A.6080705@cn.fujitsu.com>
Date: Mon, 21 Jan 2008 14:14:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Yinghai Lu <Yinghai.Lu@sun.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: update e820 instead of updating end_pfn v2
References: <200801192045.17291.yinghai.lu@sun.com> <200801210658.04030.ak@suse.de> <1200895558.5724.235.camel@brick> <200801210708.55798.ak@suse.de>
In-Reply-To: <200801210708.55798.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> That change is good agreed, but I would suggest to put it into a separate
>>> patch with a description
>>>
>> Perhaps like this:
>>
>> if (l & (Tom2Enabled|Tom2ForceMemTypeWB))
>> 	return 1;
> 
> That's not equivalent.
> 
> -Andi
> 

The equivalence is:

if ((1 & Tom2Enabled) && (1 & Tom2ForceMemTypeWB))
	return 1;
