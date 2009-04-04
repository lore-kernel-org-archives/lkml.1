Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZDDTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZDDTVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZDDTVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:21:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbZDDTVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:21:07 -0400
Message-ID: <49D7B320.4000506@vlnb.net>
Date: Sat, 04 Apr 2009 23:21:04 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stgt@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 different SCSI targets (SCST, STGT, IET, LIO)
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org>
In-Reply-To: <49D7B122.50103@wpkg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18aLnE82l546ojXiRw20tzLgFhoXfUsh68IowN
 YHtgOQBmY+pYVv5pdKxrOb8EFERqCkAsW5uILNUQ5hgVXenNx8
 BS2WVOrNckWUybncfLrcQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski, on 04/04/2009 11:12 PM wrote:
> Vladislav Bolkhovitin schrieb:
>> Hi All,
>>
>> I set up http://scst.sourceforge.net/comparison.html page, which 
>> compares features of existing SCSI target subsystems for Linux. The 
>> comparison includes SCST, STGT, IET and LIO.
>>
>> I might be not fully correct somewhere, so, if you don't agree with me 
>> about some item(s) in the comparison table, please let me know and I 
>> will fix that.
> 
> Performance is a bit debatable.

The result "in average" was listed in the comparison. Of course, one 
target can be better somewhere, another one somewhere else. That a 
nature of storage: it's pretty hard to optimize for all at once.

BTW, if I remember correctly your logs, you didn't apply all the SCST 
kernel patches on your kernel. Then your results aren't much applicable 
to this comparison, because it assumes all SCST kernel patches applied.

> I made some simple SCST and STGT tests last week, there were some where 
> SCST won, there were some where STGT won.
> 
> What was surprising to me, although STGT has a bigger CPU impact than 
> SCST, STGT was faster when reading from an encrypted (dm-crypt) volume, 
> on a system where the CPU is the bottleneck (it can't decrypt as fast as 
> HDD can deliver data).
> 
> STGT was much slower when reading from a non-encrypted volume, when 
> target had "blockdev --setra 16384 ..." for a given target.
> On the other hand, STGT was faster than SCST with default blockdev 
> readahead settings (256).
> 
> If anyone's interested, I can show results in a readable form on Monday 
> (right now, I have only raw data which is pretty long and would be hard 
> to compare).
> 
> 
> 

