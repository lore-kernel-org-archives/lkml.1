Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYKVMde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYKVMde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbYKVMdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:33:25 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:34502 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505AbYKVMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qzFxJzYlYN7f5aYHKpBF5zlhBZBCHltsjRBHVKHuzyZ5AcUk6Jffb3IerhIAZBloi9
         +AeOJmFvSXBI0EAeNCsImmWzLgsfsmmcK1l2wcscxoz7dpjPyfel0V+aZ3GMB1ppKs9J
         3T+2ItJJawhRRXk432MWfoJVAuSsXRBgh9lQE=
Message-ID: <4927FC0C.10900@gmail.com>
Date: Sat, 22 Nov 2008 14:33:16 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Derek Smithies <derek@indranet.co.nz>
CC: Bob Copeland <me@bobcopeland.com>, wally@theblackmoor.net,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet> <alpine.DEB.2.00.0811221643030.7067@monster>
In-Reply-To: <alpine.DEB.2.00.0811221643030.7067@monster>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Derek Smithies wrote:
> Hi,
>  to verify that it is a rate control issue, there is one very simple and 
> very practical test.
> 
> Take both ends of your link, and set them to fixed rate, and at the rate 
> you think it should be achieving.
> If you can achieve significantly higher throughputs with fixed rate, you 
> know that the rate control algorithm (or interface with rate algorithm) 
> has failed.
> 
> Derek.
> 
> On Fri, 21 Nov 2008, Bob Copeland wrote:
> 
>> On Fri, Nov 21, 2008 at 10:28:29PM +0200, Maxim Levitsky wrote:
>>> I initially blamed iwl3945, then thought it got fixed, but now I have
>>> ath5k, and speeds are low
>>> and I suspect that both drivers has bugs regarding to speed.
>>
>> Quite possible, but both use mac80211 for rate control.  Which rate
>> control algorithm are you using?
Hi,

Well, iwl3945 was showing 54M all the time in iwconfig,
also it doesn't support setting fixed rate, at least not using iwconfig.

ath5k never shows higher that 18M, and supports setting fixed rate, but if I set it to anything higher that 18M,
speeds drop to 0Kbytes/s immediately.
Speeds lower that 18M work, and affect throughput accordantly
For most of tests speeds are ether 18M or lower, but then when I set them to 18M this didn't increase throughput.
 
iwl3945 was always at 54M



Best regards,
	Maxim Levitsky
