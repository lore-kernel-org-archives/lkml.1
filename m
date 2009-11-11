Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZKKIHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZKKIHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZKKIHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:07:05 -0500
Received: from gesmail.globaledgesoft.com ([203.76.137.4]:37807 "EHLO
	gesmail.globaledgesoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835AbZKKIHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:07:03 -0500
Message-ID: <4AFA6BEF.8040409@globaledgesoft.com>
Date: Wed, 11 Nov 2009 13:16:55 +0530
From: Naveen BN <naveen.bn@globaledgesoft.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Ram <ramaswamy.bm@globaledgesoft.com>
CC: linux-kernel@vger.kernel.org,
       Chaitra Shankar <chaitra.shankar@globaledgesoft.com>,
       timo.teras@gmail.com
Subject: Re: Error while creating security association using ip xfrm command
References: <4AE6D26D.7020607@globaledgesoft.com> <4AE6DC72.4010208@iki.fi> <4AE820B4.3070400@globaledgesoft.com> <20091028140923.GD101657@sun.com> <4AE9228D.1070107@globaledgesoft.com> <4AE938F8.9060008@iki.fi> <4AF7B4FE.5050801@globaledgesoft.com> <4AF7C346.7070105@globaledgesoft.com> <4AF7C7C5.6060204@globaledgesoft.com> <4AF84F22.4020500@iki.fi> <4AF97F5D.4060802@globaledgesoft.com> <4AF9A77D.2060302@iki.fi> <4AFA4A35.30203@globaledgesoft.com>
In-Reply-To: <4AFA4A35.30203@globaledgesoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Problem can be solved by using the below command 

ip xfrm state add src 172.16.8.36 dst 172.16.8.38 proto esp spi 0x800 
mode tunnel reqid 0 replay-window 32 auth sha1 
0xecf02a5cf6568556e1bdcd961c7ec3f92afd01cc enc aes 
0x5c0cfa9672ce67ba545b593076dfb278 sel src 172.16.8.36 dst 172.16.8.38 
proto udp  dport 300
please refer http://man.he.net/man8/ip

Regards
Naveen
Ram wrote:
> Directing the query to Linux kernel networking group :
>
> _*Query :*_
> *I am trying to create a security association using ip xfrm command, 
> but i get an error message saying
> "*RTNETLINK answers: Function not implemented*" and ip xfrm state 
> succeeds in displaying  sa  written using setkey .
>
> ip xfrm state add src 192.168.1.20 dst 192.168.1.5 proto esp spi 
> 0x354cb04b mode tunnel reqid 16385 replay-window 32 auth hmac 
> 0xecf02a5cf6568556e1bdcd961c7ec3f92afd01cc enc cbc 
> 0x5c0cfa9672ce67ba545b593076dfb278 sel src 0.0.0.0/0 dst 0.0.0.0/0
>
> ERROR message => "RTNETLINK answers: Function not implemented" 
> Please let me know what is the problem here .
>
>
>
> *Timo Teräs wrote:
>> Naveen BN wrote:
>>> *I am trying to create a security association using ip xfrm command, 
>>> but i get an message saying
>>> "*RTNETLINK answers: Function not implemented*" and ip xfrm state 
>>> succeeds in displaying  sa  written using setkey .
>>>
>>> ip xfrm state add src 192.168.1.20 dst 192.168.1.5 proto esp spi 
>>> 0x354cb04b mode tunnel reqid 16385 replay-window 32 auth hmac 
>>> 0xecf02a5cf6568556e1bdcd961c7ec3f92afd01cc enc cbc 
>>> 0x5c0cfa9672ce67ba545b593076dfb278 sel src 0.0.0.0/0 dst 0.0.0.0/0
>>>
>>> ERROR message => "RTNETLINK answers: Function not implemented" *
>>
>> Please, direct "ip xfrm" and Netlink questions to Linux kernel
>> networking mailing list.
>>
>> - Timo
>>

