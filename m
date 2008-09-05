Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYIENQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYIENQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYIENQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:16:35 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:52970 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYIENQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:16:34 -0400
Message-ID: <48C13111.4030205@emcraft.com>
Date: Fri, 05 Sep 2008 17:16:01 +0400
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Wolfgang Denk <wd@denx.de>
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com> <20080905130622.4C497248B8@gemini.denx.de>
In-Reply-To: <20080905130622.4C497248B8@gemini.denx.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: Spam detection software, running on the system "ocean.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Dear Wolfgang, this patch is already applied (d2029eba
	in linux-2.6-denx repo) I just sent it upstream. Regards, Ilya. [...] 
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

Dear Wolfgang,

this patch is already applied (d2029eba in linux-2.6-denx repo) I just
sent it upstream.

Regards, Ilya.

Wolfgang Denk wrote:
>> Should clear the next pointer of the TX if we are sure that the
>> next TX (say NXT) will be submitted to the channel too. Overwise,
>> we break the chain of descriptors, because we lose the information
>> about the next descriptor to run. So next time, when invoke
>> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
>> NXT will be never submitted.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>> ---
>>  crypto/async_tx/async_tx.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>     
>
> What about this patch? SHould it be applied to our repository?
>
> Best regards,
>
> Wolfgang Denk
>
>   

