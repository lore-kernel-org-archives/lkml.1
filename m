Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0BCRPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:15:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:61000 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab0BCRPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q5hF43doobUhJLZqGUdGgqkEVlghPWcLFR/VCUico9nxo7jHp80p8+ukUVpRRhCKkX
         7po33gnPd3PefneCijyTeffSqSsRHOEGUkCo5/qDXWu7wuk8UYvknuadM41R8FLCeJNi
         oNYSGBsygffhHl63KVuVlxO4nJAHRJ/yd6LS0=
Message-ID: <4B69AF7B.70402@gmail.com>
Date: Wed, 03 Feb 2010 09:16:43 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Michael Breuer <mbreuer@majjas.com>, Jarek Poplawski <jarkao2@gmail.com>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
References: <20100128223447.GC3109@del.dom.local>	<4B621316.8070308@majjas.com>	<20100128225621.GD3109@del.dom.local>	<4B6216B9.1010802@majjas.com>	<20100128153643.0fca3c51@nehalam>	<4B645EF4.4050701@majjas.com>	<20100131003449.GA11935@del.dom.local>	<4B650D53.2010607@majjas.com>	<4B65D0F9.2020602@majjas.com>	<4B65FD12.7090101@majjas.com>	<20100131221835.GA3317@del.dom.local>	<20100201102018.7b597992@nehalam>	<4B68F664.6050007@majjas.com>	<4B69A897.7030408@majjas.com> <20100203085618.6662cc6f@nehalam>
In-Reply-To: <20100203085618.6662cc6f@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/10 08:56, Stephen Hemminger wrote:
> On Wed, 03 Feb 2010 11:47:19 -0500
> Michael Breuer<mbreuer@majjas.com>  wrote:
>
>> Tracked this down. The status being returned is 0x3c0080 - good flow
>> control packets. Nothing is actually being dropped (confirmed by packet
>> trace on switch compared with packet trace on server).
>>
>> I whipped up a trivial patch to not count these as dropped packets and
>> will post to netdev.
>>
>> I'm not really sure what the driver should be doing in this case, but
>> resubmit seems to work.
>
> Looks like a flow control negotiation issue. You probably turned off
> flow control on the Linux side, but the switch is still doing flow
> control.
>

I noticed this in a hotel last week, I can try
at the home to see if this fires of, if so
I can test any patches you have.

Justin P. Mattock
