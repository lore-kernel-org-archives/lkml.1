Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZGJIn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZGJIn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZGJIns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:43:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZGJInr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:43:47 -0400
Message-ID: <4A56FF32.2060303@vlnb.net>
Date: Fri, 10 Jul 2009 12:43:30 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, hifumi.hisashi@oss.ntt.co.jp,
       linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com,
       randy.dunlap@oracle.com, Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net> <4A4DE3C1.5080307@vlnb.net>	 <a0272b440907040819l5289483cp44b37d967440ef73@mail.gmail.com>	 <4A51DC0A.10302@vlnb.net>	 <a0272b440907060737n59d4b155lb40c1c6d38ee96dd@mail.gmail.com>	 <4A5238EC.1070505@vlnb.net>	 <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com>	 <4A5395FD.2040507@vlnb.net>	 <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com>	 <4A5493A8.2000806@vlnb.net> <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>
In-Reply-To: <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/F/JQ8ggQ3hl9jLuljm3pp4lTIHPcjSb4wa7U
 KKH4UthTc4UoMPpaPdCmx6t0CgDiDVVUAaGRnK1KQaexvk+Erz
 fuHgZlP8IOHAjY2yJ4ukg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ronald Moesbergen, on 07/10/2009 10:32 AM wrote:
>> I've also long ago noticed that reading data from block devices is slower
>> than from files from mounted on those block devices file systems. Can
>> anybody explain it?
>>
>> Looks like this is strangeness #2 which we uncovered in our tests (the first
>> one was earlier in this thread why the context RA doesn't work with
>> cooperative I/O threads as good as it should).
>>
>> Can you rerun the same 11 tests over a file on the file system, please?
> 
> I'll see what I can do. Just te be sure: you want me to run
> blockdev-perftest on a file on the OCFS2 filesystem which is mounted
> on the client over iScsi, right?

Yes, please.

> Ronald.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
