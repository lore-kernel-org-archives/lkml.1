Return-Path: <linux-kernel-owner+w=401wt.eu-S1764333AbYHFDxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764333AbYHFDxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYHFDxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:53:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2584 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYHFDxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:53:22 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5354"; a="5349355"
Message-ID: <4899202B.6030303@qualcomm.com>
Date: Tue, 05 Aug 2008 20:53:15 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>	<20080802063900.6615e5ca.pj@sgi.com>	<48948C3A.6050805@qualcomm.com>	<20080802225127.2b0d138b.pj@sgi.com>	<4895F3ED.4020805@qualcomm.com>	<20080804010033.0d1b0549.pj@sgi.com>	<48977E81.4040207@qualcomm.com>	<20080804225636.541527e8.pj@sgi.com>	<4898B873.6000308@qualcomm.com>	<20080805180521.be7010e1.pj@sgi.com>	<48991973.90109@qualcomm.com> <20080805222927.6dd95f5f.pj@sgi.com>
In-Reply-To: <20080805222927.6dd95f5f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> But it does seem like an overkill to schedule a workqueue ...
> 
> "overkill" -- by what metric?
> 
> If something is overkill, it means something is excessive.
> Excess (and deficiency) occur along some scale, some metric.
> 
> If not by CPU cycles, then by what metric is it overkill?
> 

Paul, I think you're focusing on the wrong part of my reply ;-).
You are, of course, correct about the overkill metric. I was saying
that saving cycles in that path was not my goal when I wrote
the patch. I just added necessary functions to make existing paths
work they way they currently do and only changed one path because
it had to change due to lock nesting issues.
Along the way simply pointed it out that scheduling work unnecessarily
does seem less efficient. That was not the important part though :)

Max

