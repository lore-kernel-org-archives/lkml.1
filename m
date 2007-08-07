Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbXHGAYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbXHGAYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 20:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933402AbXHGAYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 20:24:36 -0400
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:20431 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933315AbXHGAYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 20:24:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:In-Reply-To:References:Mime-Version:Content-Type:Message-Id:Cc:Content-Transfer-Encoding:From:Subject:Date:To:X-Mailer;
  b=0QIO1XIGY+xiG+fA8JhO/zIJus6T5QrXIp0lLQtfzPXX6z6hnPDJ0dMuqlH3K2u8eEgFSI13nVPdj0Zm1PtnvP82a2QwdKC9eLwYdEz90uq5Xx11dYCGnX1IUCP/oqk+4dRHXVCvrhG1ecW2ok697jaQRYVkuPE1WSgRbwLbA10=  ;
X-YMail-OSG: n44GiY8VM1kft.VcAVfsLhK_jJycijrYBCPI9zyPk0LuI9ING7BmDWFZ1J3Re2IjOA40oCLJcMNZRWjhmEd1XLTEEJGSNbWsFdL3.1.qA54peVLUNpSqMYS4EAzMDDFO6FrDp78igjOaeMk-
In-Reply-To: <18103.44797.529894.786033@gargle.gargle.HOWL>
References: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net> <18103.44797.529894.786033@gargle.gargle.HOWL>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E210D1E9-9265-48EE-91BB-E6027547F01E@sbcglobal.net>
Cc: linux-ppp@vger.kernel.org,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kevin K <k_krieser@sbcglobal.net>
Subject: Re: sending raw packets via PPP
Date: Mon, 6 Aug 2007 19:24:31 -0500
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

I was basing the raw mode on comments in the DHCP source code about  
problems in older Linux kernels with sending packets to  
255.255.255.255 via normal IP.  The DHCP source code therefore wants  
to send raw packets (SOCKET_PACKET) (down to the ethernet addressing  
info).  I guess I thought I would need to do this too to fit in with  
the existing source code.

I'll give it a try to see whether packets sent to 255.255.255.255 can  
make it to ppp with the IP address unchanged.

Thanks,
