Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYGAI34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYGAI34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbYGAI2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:28:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:10268 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735AbYGAI2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uBeon29MiPvgMBz6sAjWndpw2MkfVjE+QLXp7Q5jT+PG/PVtSuqZN5v0SjzA5Tl6IS
         52ENJwVpxhX8VExGW2Qd9ZIsaAXHKXkEXe6XN/PScG+joS6HtPJGPSkDjsxFRuuj8YiH
         zaUBUA2ldYXmvG/3TolY6ZyBEEiXR0tmmp7h4=
Message-ID: <4869EABD.1090009@gmail.com>
Date: Tue, 01 Jul 2008 11:28:45 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Peterson <joe@skyrush.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local> <87abh2rpzg.fsf@denkblock.local>
In-Reply-To: <87abh2rpzg.fsf@denkblock.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
> [...]
>   
>> The following patch to 2.6.26-rc8 fixes the issue for me.
>>     
>
> Sorry, resending without MIME encoding the message.
>
> Regards,
>
> Elias
>
>
> --------
> From: Elias Oltmanns <eo@nebensachen.de>
> Subject: Make sure that interrupt characters get through reliably
>
> Since commit ec5b1157f8e819c72fc93aa6d2d5117c08cdc961, users have been
> unable to interrupt interactive processes reliably by pressing CTRL+C.
> This patch reverts the original commit except for the most important
> part: actually echoing ^C is preserved.
>   

Thanks for the patch , the process seems to respond faster to Ctrl-C,
but I'll have to find a way to measure that reliably.
However ^C is not echoed anymore for me.

Best regards,
--Edwin
