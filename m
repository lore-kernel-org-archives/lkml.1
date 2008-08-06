Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYHFUgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYHFUgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYHFUgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:36:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59070 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbYHFUge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:36:34 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5204177"
Message-ID: <489A0B4F.2020803@qualcomm.com>
Date: Wed, 06 Aug 2008 13:36:31 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>	<20080802063900.6615e5ca.pj@sgi.com>	<48948C3A.6050805@qualcomm.com>	<20080802225127.2b0d138b.pj@sgi.com>	<4895F3ED.4020805@qualcomm.com>	<20080804010033.0d1b0549.pj@sgi.com>	<48977E81.4040207@qualcomm.com>	<20080804225636.541527e8.pj@sgi.com>	<4898B873.6000308@qualcomm.com>	<20080805180521.be7010e1.pj@sgi.com>	<48991973.90109@qualcomm.com>	<20080805222927.6dd95f5f.pj@sgi.com>	<4899202B.6030303@qualcomm.com>	<20080805232856.78dd50f7.pj@sgi.com>	<489930B5.9030906@qualcomm.com>	<20080806004629.d321f3b0.pj@sgi.com>	<489A079E.5040903@qualcomm.com> <20080806152910.9e4f76a2.pj@sgi.com>
In-Reply-To: <20080806152910.9e4f76a2.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max K wrote:
>> Sure. That looks fine. Although inline_ will probably be a bit confusing 
>> since one may think that it has something to do with the C 'inline'.
>> I'd suggest either sync_rebuild_sched_domains() or simply 
>> rebuild_sched_domains().
> 
> Good point about "inline" confusions.
> 
> I am willing to agree to "sync_rebuild_sched_domains()".

Thank you. I'll go ahead and respin the patch.

Max
