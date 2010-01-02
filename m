Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515Ab0ABFxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0ABFxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 00:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458Ab0ABFxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 00:53:55 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:62152 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0ABFxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 00:53:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VJH1FLaNO6PpFpaDYW/nzxhTG75E8mHWtnF9EnQhE7AROEkJv/J1dxnmlAHUtLafJ4
         9Kd0Qj5hJnxV3Mob/dHuwZswydpzsXNrsWsHir/amE1Q5K2SBMF09W1Ye8Fti3vn4y1i
         8ARpE+JLmRKU3vpGRHxOLJ4zSpOBOdUKe81yU=
MIME-Version: 1.0
In-Reply-To: <1262384490.16706.4.camel@wall-e>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	 <1262274494.14143.7.camel@wall-e>
	 <20100101155630.1A1E.A69D9226@jp.fujitsu.com>
	 <1262358616.11460.18.camel@wall-e> <20100101220529.GL4620@const>
	 <1262384490.16706.4.camel@wall-e>
Date: Sat, 2 Jan 2010 14:53:52 +0900
X-Google-Sender-Auth: 60a28399081d74a5
Message-ID: <2f11576a1001012153qec2ea0eo7a2762386ed22273@mail.gmail.com>
Subject: Re: [PATCH] proc: revert to show stack information in 
	/proc/{pid}/status
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/2 Stefani Seibold <stefani@seibold.net>:
> Am Freitag, den 01.01.2010, 23:05 +0100 schrieb Samuel Thibault:
>> Stefani Seibold, le Fri 01 Jan 2010 16:10:16 +0100, a écrit :
>> > But ps is not a performance critical application nor a cat
>> > /proc/*/status!
>>
>> Errr, maybe not so much as some other operations, but a lot of tools use
>> them, so it's really worth considering it.
>
> Right. And i am still trying to find some optimization. Stay tuned.

I can understand you feel sad. but don't worry. reverting is very usual event
on kernel development. You can retry anytime if you make optimized code.
