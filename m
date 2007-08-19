Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXHSXql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXHSXql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 19:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbXHSXq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 19:46:29 -0400
Received: from smtp110.sbc.mail.re2.yahoo.com ([68.142.229.95]:26938 "HELO
	smtp110.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755594AbXHSXq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 19:46:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:In-Reply-To:References:Mime-Version:Content-Type:Message-Id:Cc:Content-Transfer-Encoding:From:Subject:Date:To:X-Mailer;
  b=Yd3ZctWbdfTiPvAXUBpAjaBGf1w/1AS2/8PwoC4Eh8eDQkLFPehb2s7W/UpGdTdoZBSnOzaLmuBeZu3ieTpoVnOmJTTRqkS+E54Hi2LyAWGCOLguxcv+T3Qb+T9MvBeTekJVAUa/QKWSBDYRFgu+tBgS/16sZut2o7/qrR+VTLE=  ;
X-YMail-OSG: 4gx9dzMVM1l38hmfKZ564HDcbkx5N7InSWS6VKK3sKFS6xUrhbYEoPDS_Kpa5Jl17pHXsJoKUA--
In-Reply-To: <18103.44797.529894.786033@gargle.gargle.HOWL>
References: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net> <18103.44797.529894.786033@gargle.gargle.HOWL>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F46FFDA7-6FB2-4700-9A53-0B43F8736A70@sbcglobal.net>
Cc: linux-ppp@vger.kernel.org,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kevin K <k_krieser@sbcglobal.net>
Subject: Re: sending raw packets via PPP
Date: Sun, 19 Aug 2007 18:46:21 -0500
To: James Carlson <carlsonj@workingcode.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 6, 2007, at 6:30 PM, James Carlson wrote:

> Kevin K writes:
>> Is it possible to send raw packets via ppp under Linux?
>>
>> More specifically, in 2.4 series kernels such as RH's 2.4.21-47  
>> kernel?
>>
>> I've trying to modify the DHCP 3.0.1 code provided with RH 3 so I can
>> send requests via a PPP connection (standard RS-232), and it is just
>> being dropped by the stack according to ifconfig and debug statements
>> in ppp_generic.c.
>
> I'm not sure what sort of "raw" packets you're talking about (IP raw
> or something else), but you shouldn't need to send any raw packets to
> do this.  DHCP runs over UDP, and, unlike Ethernet, there's no link
> layer addressing to worry about.
>
> -- 
> James Carlson         42.703N 71.076W          
> <carlsonj@workingcode.com>


I would like to thank the people who responded to this posting for  
their help.  It helped keep me from wasting additional time trying to  
use SOCK_PACKET over PPP just because the DHCP code in Red Hat used  
it for ethernet.  (The dhclient code did it to ensure that the  
ethernet/IP/UDP headers were to their satisfaction, and to avoid some  
bugs in older versions of the Linux kernel).

I've tested through a serial/PPP connection without issues.

This is obviously not a normal configuration, having to run a DHCP  
client through PPP, but the IP addresses are assigned via a DHCP  
server, but he router we connect to via PPP won't retrieve addresses  
from the DHCP server for us.

Thanks,
Kevin
