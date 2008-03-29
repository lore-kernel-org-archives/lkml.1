Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYC2RZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYC2RZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYC2RZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:25:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:53103 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYC2RZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:25:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=W3AfnlLiwaPO3iu05VYxSSIQjgASyb1gSRQSk56EU6q/03L20XMJ7rmQ2Uuw8VLfJqt7PMOdqyWSnzaVU2jjsgrr5mW3pLtCJQGo1QKAAEfzHZ+llM0eHXrHQkDgr8aC9IBPuMNsPIoz3+4KQol8hYXv48aR6Lnot7FuCvAjPLY=
Message-ID: <47EE7AF0.5070306@gmail.com>
Date: Sat, 29 Mar 2008 18:22:56 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
References: <47EE75A0.8070705@gmail.com> <18414.31274.514325.238985@harpo.it.uu.se>
In-Reply-To: <18414.31274.514325.238985@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson pisze:
> Jacek Luczak writes:
>  > Hi All,
>  > 
>  > I've found that in many enum lists, there's a comma at the end, e.g. 
>  > (arch/x86/kernel/early_printk.c):
>  > 
>  > enum {
>  >          MAGIC1 = 0xBACCD00A,
>  >          MAGIC2 = 0xCA110000,
>  >          XOPEN = 5,
>  >          XWRITE = 4,
>  > };
>  > 
>  > Just out of curiosity, is there any particular reason here (no word in 
>  > CodingStyle about that).
> 
> Yes. This idiom allows you to add or remove items without
> changing adjacent lines.

Yep, that's obvious, one line less in diff after every enum change  :)

> In a language with strict a comma-as-separator rule you can
> get this benefit by placing the comma before new items rather
> than after existing items:
> 
> enum {	FOO
> 	,FIE
> 	,FUM
> };
> 
> but luckily C doesn't need this perversion.
> 

I was just curious, because it's not common schema (some miss extra comma).

Thanks,
	-Jacek
