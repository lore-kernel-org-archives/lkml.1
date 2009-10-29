Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZJ2Ks6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZJ2Ks6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 06:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbZJ2Ks5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 06:48:57 -0400
Received: from mail-forward2.uio.no ([129.240.10.71]:36800 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZJ2Ksz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 06:48:55 -0400
References: <4AE7207D.8090402@simula.no> <4AE7AFC4.3040805@gmail.com>
In-Reply-To: <4AE7AFC4.3040805@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Message-Id: <64F26430-3673-4D72-8D09-518DBF6D6438@simula.no>
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi, davem@davemloft.net
From: Andreas Petlund <apetlund@simula.no>
Subject: Re: [PATCH 3/3] net: TCP thin dupack
Date: Thu, 29 Oct 2009 11:48:55 +0100
To: William Allen Simpson <william.allen.simpson@gmail.com>
X-Mailer: Apple Mail (2.1076)
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 11 sum msgs/h 2 total rcpts 361 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-4.5, required=5.0, autolearn=disabled, TVD_RCVD_IP=0.502,UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D51E630A19C443EB167690ABEEB6F2798BDA9591
X-UiO-SPAM-Test: remote_host: 213.23.10.101 spam_score: -44 maxlevel 80 minaction 2 bait 0 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Den 28. okt. 2009 kl. 03.43 skrev William Allen Simpson:

> Andreas Petlund wrote:
>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>> index e64368d..f4a05ff 100644
>> --- a/include/linux/tcp.h
>> +++ b/include/linux/tcp.h
>> @@ -97,6 +97,7 @@ enum {
>> #define TCP_CONGESTION		13	/* Congestion control algorithm */
>> #define TCP_MD5SIG		14	/* TCP MD5 Signature (RFC2385) */
>> #define TCP_THIN_RM_EXPB        15      /* Remove exp. backoff for  
>> thin streams*/
>> +#define TCP_THIN_DUPACK         16      /* Fast retrans. after 1  
>> dupack */
>>
> I've not had the chance to examine the rest, but I've been poking at a
> patch series that's used 15 for over a year, so could you try 16 and  
> 17?

Thank you for the feedback. I will address this in the next patch  
iteration.
