Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYC2R3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYC2R3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYC2R3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:29:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:17510 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYC2R3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pTlcOrHqPQu9f26MELcULeFcMEH88q6IgH17Gz7vuCxRbAMe/S7biSqWoIPXl1SMJUKqFnTuG8G302cXGWrWocJWXDK5dg7yF0YTGHzDauAjidoUYl8vCMbnL4AhYMCNVgBH0c+1uol6GDAiX5pQ9SVyuT5qQpr4ia3VUrdMCBE=
Message-ID: <47EE7BC9.2000009@gmail.com>
Date: Sat, 29 Mar 2008 18:26:33 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
References: <47EE75A0.8070705@gmail.com> <47EE7A66.30905@zytor.com> <20080329172551.GA9785@ZenIV.linux.org.uk>
In-Reply-To: <20080329172551.GA9785@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro pisze:
> On Sat, Mar 29, 2008 at 10:20:38AM -0700, H. Peter Anvin wrote:
>> Jacek Luczak wrote:
>>> Hi All,
>>>
>>> I've found that in many enum lists, there's a comma at the end, e.g. 
>>> (arch/x86/kernel/early_printk.c):
>>>
>>> enum {
>>>        MAGIC1 = 0xBACCD00A,
>>>        MAGIC2 = 0xCA110000,
>>>        XOPEN = 5,
>>>        XWRITE = 4,
>>> };
>>>
>>> Just out of curiosity, is there any particular reason here (no word in 
>>> CodingStyle about that).
>>>
>> Yes, it's so you can add a line without affecting the line before it, 
>> making a one-line patch into a two-line patch that's more likely to 
>> conflict.
> 
> Note that doing that makes sense only when you can expect additions to
> the end and even then it's a matter of taste.
> 

I think it's hard to ,,expect additions'' or just predict them. But 
smaller patch (diff) is one of things that makes sens of adding extra 
commas. I'm just pedantic here.

-Jacek
