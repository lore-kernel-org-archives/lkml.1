Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZKHPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZKHPgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZKHPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:36:46 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:61089 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZKHPgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:36:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E6gGJx3EgrBMLoE3hvp8VF28n/kCVMHEagUNgMaqNsXvJEfQhZFSCIdBG1dNEEgHWa
         maoCsHmy1NvJl3bH/q44wwmNJr321g+vnAcc4duVggmZTTD2oyS6WZBY+gsC0zw49iEl
         59ekqQZucrzkgiqPpFtwpUECa2JpPFZRMcDx8=
MIME-Version: 1.0
In-Reply-To: <20091108110237.GG11372@elte.hu>
References: <b8bf37780911040648h7e4bae3dg21ce15c6b0e680d3@mail.gmail.com> 
	<20091108110237.GG11372@elte.hu>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 8 Nov 2009 13:36:31 -0200
Message-ID: <b8bf37780911080736m15a9d653q51de108060d1aeaa@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] vsprintf: factorize "(null)" string
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo!

On Sun, Nov 8, 2009 at 9:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andr? Goddard Rosa <andre.goddard@gmail.com> wrote:
>
>> @@ -546,12 +548,12 @@ static char *number(char *buf, char *end,
>> unsigned long long num,
>>       return buf;
>>  }
>>
>> -static char *string(char *buf, char *end, char *s, struct printf_spec spec)
>> +static char *string(char *buf, char *end, const char *s, struct
>> printf_spec spec)
>
> FYI, your patches have such linewraps, so the patches wont apply:
>
>  patch: **** malformed patch at line 47: unsigned long long num,
>
> See Documentation/email-clients.txt about how to send patches without
> such problems.
>
> Mind resending with this fixed?

I tried to fix these by using send-email this time. Please let me know
if you still see any issue.

> Also, this RFC patch of yours:
>
>  vsprintf: reuse almost identical simple_strtoulX() functions
>
> looks nice too IMO - mind including it in your series?

Can I consider it as an Acked-by?  ;-)

Just sent v4 now.

Thank you,
André
