Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0BJNtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:49:24 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:35179 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab0BJNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:49:22 -0500
Message-ID: <4B72B95A.10402@simula.no>
Date: Wed, 10 Feb 2010 14:49:14 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       =?UTF-8?B?SWxwbyBK?= =?UTF-8?B?w6RydmluZW4=?= 
	<ilpo.jarvinen@helsinki.fi>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
Subject: Re: [net-next PATCH v2 2/3] net: TCP thin linear timeouts
References: <4B701EE2.1000006@simula.no> <1265697119.4236.99.camel@edumazet-laptop>
In-Reply-To: <1265697119.4236.99.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 13 sum msgs/h 1 total rcpts 770 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 64125C9A56FF7648B3982E0FA987712B28F02FEB
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 20 total 19169 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 07:31 AM, Eric Dumazet wrote:
> Le lundi 08 février 2010 à 15:25 +0100, Andreas Petlund a écrit :
>>  
>> +	case TCP_THIN_LT:
>> +		if (val)
>> +			tp->thin_lt = 1;
>> +		break;
>> +
> 
> Why not allowing user to clear thin_lt ?
> 
> 

That is a very good point. I will fix that in the next iteration,
as well as error handling for out of bounds values.

Best regards,
Andreas
