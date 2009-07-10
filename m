Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbZGJJ1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbZGJJ1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZGJJ1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:27:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZGJJ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:27:39 -0400
Message-ID: <4A570981.5080803@vlnb.net>
Date: Fri, 10 Jul 2009 13:27:29 +0400
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
References: <4A3CD62B.1020407@vlnb.net> <4A4DE3C1.5080307@vlnb.net>	 <a0272b440907040819l5289483cp44b37d967440ef73@mail.gmail.com>	 <4A51DC0A.10302@vlnb.net>	 <a0272b440907060737n59d4b155lb40c1c6d38ee96dd@mail.gmail.com>	 <4A5238EC.1070505@vlnb.net>	 <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com>	 <4A5395FD.2040507@vlnb.net>	 <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com>	 <4A5493A8.2000806@vlnb.net> <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com> <4A56FF32.2060303@vlnb.net>
In-Reply-To: <4A56FF32.2060303@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18PAlt+ZTWLajFCvGmL0K5MUcoHg7xXqpW4YQQ
 qlrzD/EVdKzNo09v0R6+MDK2695rpNQO1WgXqnGLjxdZNUB4/y
 Uf1bD1mfF6LWdmSkyeMVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Vladislav Bolkhovitin, on 07/10/2009 12:43 PM wrote:
> Ronald Moesbergen, on 07/10/2009 10:32 AM wrote:
>>> I've also long ago noticed that reading data from block devices is slower
>>> than from files from mounted on those block devices file systems. Can
>>> anybody explain it?
>>>
>>> Looks like this is strangeness #2 which we uncovered in our tests (the first
>>> one was earlier in this thread why the context RA doesn't work with
>>> cooperative I/O threads as good as it should).
>>>
>>> Can you rerun the same 11 tests over a file on the file system, please?
>> I'll see what I can do. Just te be sure: you want me to run
>> blockdev-perftest on a file on the OCFS2 filesystem which is mounted
>> on the client over iScsi, right?
> 
> Yes, please.

Forgot to mention that you should also configure your backend storage as 
a big file on a file system (preferably, XFS) too, not as direct device, 
like /dev/vg/db-master.

Thanks,
Vlad

