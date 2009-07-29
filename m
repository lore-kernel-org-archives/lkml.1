Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZG2US5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZG2US5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZG2US4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:18:56 -0400
Received: from p02c12o143.mxlogic.net ([208.65.145.76]:42765 "EHLO
	p02c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbZG2US4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:18:56 -0400
X-MXL-Hash: 4a70aeb02335b401-62f2f23037c806f946e07063b617ae648f3e78ea
X-MXL-Hash: 4a70aead3b683ce3-2261d097c2dbd36a0d792a503e01ed855dc1016c
Message-ID: <4A70AEA6.9030209@steeleye.com>
Date: Wed, 29 Jul 2009 16:18:46 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, ian.campbell@citrix.com
Subject: Re: [BUG] raid1 behind writes alter bio structure illegally
References: <4A707578.3010901@steeleye.com> <4A707F85.5090008@redhat.com>
In-Reply-To: <4A707F85.5090008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2009 20:18:46.0974 (UTC) FILETIME=[C70FB5E0:01CA1089]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009071501)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
X-AnalysisOut: [v=1.0 c=1 a=kEyi0UVK3foA:10 a=m0bDsMyWfisirut6+qvwwQ==:17 ]
X-AnalysisOut: [a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=izhlqkiSO88rIdxKRC4A:9]
X-AnalysisOut: [ a=WRe3XeO01SS7RxqpiuwA:7 a=BR6WGycS5RXLvk2o4v2UEvJ_piUA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz wrote:
> Hi Paul,
> 
> Paul Clements wrote:
>> I've run into this bug on a 2.6.18 kernel, but I think the fix is still 
>> applicable to the latest kernels (even though the symptoms would be 
>> slightly different).
>>
>> Perhaps someone who knows the block and/or SCSI layers well can comment 
>> on the legality of attaching new pages to a bio without fixing up the 
>> internal bio counters (details below)?
> 
>> LVM over raid1 over SCSI/nbd
> 
> Please can you try that backporting of this patch helps?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5d84070ee0a433620c57e85dac7f82faaec5fbb3
> 
> (If so, see https://bugzilla.redhat.com/show_bug.cgi?id=512387)

Thanks Milan. I tested the patch and it does fix the issue. I replied to 
the bugzilla report with this information.

--
Paul
