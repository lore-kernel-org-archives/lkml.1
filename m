Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXEMX0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXEMX0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbXEMXZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:25:55 -0400
Received: from mail.tmr.com ([64.65.253.246]:35602 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbXEMXZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:25:54 -0400
Message-ID: <46479E95.6050507@tmr.com>
Date: Sun, 13 May 2007 19:26:13 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] "volatile considered harmful" document
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no>	<fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no> <4646082D.2080502@shaw.ca> <m33b208z5f.fsf@maximus.localdomain>
In-Reply-To: <m33b208z5f.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Robert Hancock <hancockr@shaw.ca> writes:
>
>   
>> You don't need volatile in that case, rmb() can be used.
>>     
>
> rmb() invalidates all compiler assumptions, it can be much slower.
>   
Yes, why would you use rmb() when a read of a volatile generates optimal 
code?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

