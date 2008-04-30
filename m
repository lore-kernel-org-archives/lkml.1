Return-Path: <linux-kernel-owner+w=401wt.eu-S934436AbYD3Wd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436AbYD3Wd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYD3WdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:33:18 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2233 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbYD3WdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:33:17 -0400
Message-ID: <4818F394.9000807@linuxtv.org>
From: mkrufky@linuxtv.org
To: bunk@kernel.org
Cc: mchehab@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Date: Wed, 30 Apr 2008 18:32:52 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20080430200139.GG29330@cs181133002.pp.htv.fi>
x-originalarrivaltime: 30 Apr 2008 22:29:42.0293 (UTC) FILETIME=[AF3E0450:01C8AB11]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Apr 30, 2008 at 04:52:14PM -0300, Mauro Carvalho Chehab wrote:
>   
>> On Wed, 30 Apr 2008 15:31:42 -0400
>> mkrufky@linuxtv.org wrote:
>>
>>     
>>>> Are there actually reports from users running into this problem?
>>>>         
>> No.
>>
>> Yet, the configuration may be valid. If you have a board with tda8290, it
>> _will_ need another chip, like tda827x.
>>
>> In the past, both tda8290 and tda827x were handled by the same driver,
and
>> worked for analog only.
>>
>> So, IMO, this is a regression.
>> ...
>>     
>
> drivers/media/ is the part of the kernel with the most fragile kconfig
> constructs.
>
> And we are talking about bringing a solution into -stable that has never 
> and will never be in mainline.
>
> A compile error in a configuration without practical relevance isn't a 
> huge problem, and I'd vote for leaving -stable unchanged.
I agree wholeheartedly -- we should not change the build procedure for 
the -stable series.

I hope nobody was seriously considering throwing in this sort of monkey 
wrench to a stable kernel.

-Mike

