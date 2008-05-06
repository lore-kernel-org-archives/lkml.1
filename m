Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbYEFXJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbYEFXJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYEFXJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:09:34 -0400
Received: from simmts8-qfe0.srvr.bell.ca ([206.47.199.166]:51255 "EHLO
	simmts8-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbYEFXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:09:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsBAOqBIEicIp8z/2dsb2JhbAAIim6iLg
Message-ID: <4820E529.2030801@gmail.com>
Date: Tue, 06 May 2008 20:09:29 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: arjan@linux.intel.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <20080501043313.02205bbd@linux.intel.com>	<481CF3B1.2020307@gmail.com>	<4820B64D.4000805@linux.intel.com> <20080506.133416.241365936.davem@davemloft.net>
In-Reply-To: <20080506.133416.241365936.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 06 May 2008 12:49:33 -0700
> 
>> this is weird; something is adding ANOTHER -fstack-protector to the (effective) gcc
>> flags.. which might be overriding the -fstack-protector-all setting.
>>
>> I wonder if this is a distro special ;(
> 
> Ubuntu adds -fstack-protector to the GCC command line.
> 
> But I've been able to override it trivially when, for example, doing
> GCC builds, by simply adding -fno-stack-protector.

I assume adding -fno-stack-protector would not really be an option in 
this case (since if I understand correctly it would be appended to the 
end of the flags which would turn the option off).

I guess I'll be figuring out how to build my own gcc...

-- 
Kevin Winchester
