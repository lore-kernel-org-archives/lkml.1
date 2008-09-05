Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYIEJQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYIEJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYIEJQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:16:18 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:50734 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYIEJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:16:17 -0400
Message-ID: <48C0F8BE.7060108@emcraft.com>
Date: Fri, 05 Sep 2008 13:15:42 +0400
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wd@denx.de,
       yur@emcraft.com, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com> <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
In-Reply-To: <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: Spam detection software, running on the system "ocean.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Andrew Morton wrote: >> From: Yuri Tikhonov
	<yur@emcraft.com> >> >> Should clear the next pointer of the TX if we
	are sure that the >> next TX (say NXT) will be submitted to the channel
	too. Overwise, >> we break the chain of descriptors, because we lose the
	information >> about the next descriptor to run. So next time, when
	invoke >> async_tx_run_dependencies() with TX, it's TX->next will be
	NULL, and >> NXT will be never submitted. >> >> Signed-off-by: Yuri
	Tikhonov <yur@emcraft.com> >> Signed-off-by: Ilya Yanok
	<yanok@emcraft.com> [...] 
	Content analysis details:   (-4.4 points, 2.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> From: Yuri Tikhonov <yur@emcraft.com>
>>
>> Should clear the next pointer of the TX if we are sure that the
>> next TX (say NXT) will be submitted to the channel too. Overwise,
>> we break the chain of descriptors, because we lose the information
>> about the next descriptor to run. So next time, when invoke
>> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
>> NXT will be never submitted.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>>     
Signed-off-by: Ilya Yanok <yanok@emcraft.com>

> This patch should include your signed-off-by: as well.  Because you
> were on the delivery path, as described in
> Documentation/SubmittingPatches, section 12.  
>   

Excuse me for being inattentive.

Regards, Ilya.

