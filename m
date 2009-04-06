Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZDFJum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZDFJum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZDFJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:45:07 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:47153 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbZDFJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:45:05 -0400
Message-ID: <49D9CF1A.3090702@wpkg.org>
Date: Mon, 06 Apr 2009 11:44:58 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stgt@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 different SCSI targets (SCST, STGT, IET, LIO)
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <49D7B320.4000506@vlnb.net>
In-Reply-To: <49D7B320.4000506@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin schrieb:
> Tomasz Chmielewski, on 04/04/2009 11:12 PM wrote:
>> Vladislav Bolkhovitin schrieb:
>>> Hi All,
>>>
>>> I set up http://scst.sourceforge.net/comparison.html page, which 
>>> compares features of existing SCSI target subsystems for Linux. The 
>>> comparison includes SCST, STGT, IET and LIO.
>>>
>>> I might be not fully correct somewhere, so, if you don't agree with 
>>> me about some item(s) in the comparison table, please let me know and 
>>> I will fix that.
>>
>> Performance is a bit debatable.
> 
> The result "in average" was listed in the comparison. Of course, one 
> target can be better somewhere, another one somewhere else. That a 
> nature of storage: it's pretty hard to optimize for all at once.

True.


> BTW, if I remember correctly your logs, you didn't apply all the SCST 
> kernel patches on your kernel. Then your results aren't much applicable 
> to this comparison, because it assumes all SCST kernel patches applied.

I made three tests:
- STGT (with standard Debian Lenny kernel)
- SCST with default build options (i.e. no "make debug2perf"), no kernel 
patches (standard Debian Lenny kernel)
- SCST + "make debug2perf", with kernel patches (Debian Lenny .config + 
SCST patches and proper option enabled)

I'll post the results shortly.


-- 
Tomasz Chmielewski
http://wpkg.org

