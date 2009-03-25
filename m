Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZCYUFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZCYUFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZCYUFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:05:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41602 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZCYUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Nj0W2Ni4xlYmR63hdrhWAZEkMsjrk32yF1CUBV2hGteywqF9CoWiH3JdsDDTpLTkLu
         UiaXU1VMTVZSkEUycy0nD6Do06W5FFRDlJSxdi7mio9+ubNpM4rftmOwWRpvx5r2iqaU
         esYATddb/dUuOppNb/XFHZF5uQkl5b2YeQbkA=
MIME-Version: 1.0
In-Reply-To: <1238010885.2500.65.camel@ht.satnam>
References: <Pine.LNX.4.64.0903252041190.14101@anakin>
	 <1238010885.2500.65.camel@ht.satnam>
Date: Wed, 25 Mar 2009 21:05:37 +0100
X-Google-Sender-Auth: 7679245be2705d39
Message-ID: <10f740e80903251305t24529e6fl1d3c850c8e4ec819@mail.gmail.com>
Subject: Re: [PATCH] module: Kill warning: label 'free_init' defined but not 
	used
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, dmitri.vorobiev@movial.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 20:54, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
> On Wed, 2009-03-25 at 20:43 +0100, Geert Uytterhoeven wrote:
>> On m68k (which doesn't do SMP), I get:
>>
>> | kernel/module.c:2291: warning: label 'free_init' defined but not used
>>
>> which was introduced by commit 6e2b75740bed35df98b8113300579e13ed2ce848
>> ("module: fix refptr allocation and release order").
>> Move the label inside the #ifdef, as the goto is protected by the same #ifdef.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>
> AFAIK, it is already fixed in -tip:
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=67f5ca081c6ace125e8ccc76b8a7d99b091abaa7

Interesting, as I noticed the problem in today's linux-next.
http://kisskb.ellerman.id.au/kisskb/buildresult/271602/
Or am I caught again by fake warnings from the bisection process?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
