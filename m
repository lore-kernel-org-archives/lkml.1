Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbYKNKEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbYKNKEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYKNKEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:04:39 -0500
Received: from h155.mvista.com ([63.81.120.155]:54509 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750984AbYKNKEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:04:39 -0500
Message-ID: <491D4D2F.4010802@ru.mvista.com>
Date: Fri, 14 Nov 2008 13:04:31 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: [PATCH] New IDE/block driver for OCTEON SOC Compact Flash interface.
References: <491C7F28.2070507@caviumnetworks.com>	<491CC0B6.8020400@ru.mvista.com> <20081114011851.1fa01a33@lxorguk.ukuu.org.uk>
In-Reply-To: <20081114011851.1fa01a33@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>> OTOH, CF support via self-contained driver is certainly a waste of code 
>> since IDE core and (libata) are here to drive the CF devices as well. 
>> What we need is a "normal" IDE or libata (at your option) driver.
>>     
>
> A libata driver would be nice and probably easiest to do as you don't
> have to pretend to be close to old style taskfile IDE for a PC.
>   

   AFAIU you don't need to pretend that with IDE as well now.

> I am not convinced there is no case for a 'dumb' small CF driver, but if
> so the chipset code and the core code need to be separated as the other
> requests I see for this are different embedded boxes wanting to keep
> codesize down.
>   

  Yeah, that might be worth considering...

> Alan
>   

WBR, Sergei


