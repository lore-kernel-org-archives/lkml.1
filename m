Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab0BUB5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 20:57:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab0BUB5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 20:57:04 -0500
Message-ID: <4B8093BA.7010809@redhat.com>
Date: Sun, 21 Feb 2010 10:00:26 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v5 3/3] net: reserve ports for applications using
 fixed port numbers
References: <1266532210-11536-1-git-send-email-opurdila@ixiacom.com> <1266532210-11536-3-git-send-email-opurdila@ixiacom.com> <4B7F9B65.1060309@redhat.com> <201002201527.37643.opurdila@ixiacom.com>
In-Reply-To: <201002201527.37643.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Saturday 20 February 2010 10:20:53 you wrote:
> 
>>> +unsigned long *sysctl_local_reserved_ports;
>>> +EXPORT_SYMBOL(sysctl_local_reserved_ports);
>>> +
>> Sorry, this looks somewhat weird, why not just export
>> inet_is_reserved_local_port()?
>>
> 
> My understanding is that if we do that than we won't be able to inline 
> inet_is_reserved_local_port().  And as David said previously that will have a 
> significant impact on performance.

Oh, that would be true probably, so just leave as it is.

Thanks.

