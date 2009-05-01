Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbZEAMlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbZEAMlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZEAMlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:41:31 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41864 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbZEAMla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:41:30 -0400
Message-ID: <49FAEDF8.5040506@hp.com>
Date: Fri, 01 May 2009 08:41:28 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Subject: [PATCH] from-sector redundant in trace_block_remap
References: <20090430133627.D217.A69D9226@jp.fujitsu.com>	 <49F9D82D.50901@hp.com> <49F9D8CC.7010502@hp.com> <2f11576a0904301908i1c0f12e5tc3f76e1ffee84a18@mail.gmail.com>
In-Reply-To: <2f11576a0904301908i1c0f12e5tc3f76e1ffee84a18@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> From f167379b6c2cbad5f4fe8492052693825980ec19 Mon Sep 17 00:00:00 2001
>> From: Alan D. Brunelle <alan.brunelle@hp.com>
>> Date: Thu, 30 Apr 2009 11:22:55 -0400
>> Subject: [PATCH] from-sector redundant in trace_block_remap
>>
>> Removed redundant from-sector parameter: it's /always/ the bio's sector
>> passed in.
> 
> please swap patch 1/2 and 2/2.
> Actually this patch remove "to" parameter. but wrong parameter name
> confuse patch description.
> 
> IOW, this patch description and changing code isn't consistent because
> there is argument to-from swapping.
> Otherthings, looks good to me.

Very good point - will re-work & re-submit.

Thanks,
Alan
