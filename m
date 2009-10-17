Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbZJQEm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbZJQEm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 00:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZJQEmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 00:42:55 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:49037 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZJQEmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 00:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AmaHfcM1JaK3qbwbCYeDBuTQpwRm9TQ5ZorUS28/U62Q/hfiXM/NgMKx+06rrQ6Nt+
         bxKd6PbSIp2FvioXLFb9GZh4q7VYopKHGeRBaObcdHNikI8A26zm9PwS5vsAF1pKmLpO
         3pz01ggRO+Bty7FuUM6Js5Do7kM2RVvjTQtqk=
MIME-Version: 1.0
In-Reply-To: <1255731737.12593.4.camel@utx.utx.cz>
References: <20091007120643.GA17069@rakim.wolfsonmicro.main> 
	<1255641385.3985.55.camel@utx.utx.cz> <20091015212024.GC15898@elf.ucw.cz> 
	<1255643252.3985.63.camel@utx.utx.cz> <20091015215215.GG15898@elf.ucw.cz> 
	<1255685315.5470.3.camel@hammer.suse.cz> <20091016093950.GI15898@elf.ucw.cz> 
	<1255719006.9583.31.camel@utx.utx.cz> <20091016190521.GB17849@n2100.arm.linux.org.uk> 
	<1255731737.12593.4.camel@utx.utx.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 17 Oct 2009 12:42:39 +0800
Message-ID: <f17812d70910162142r72d58f08gffafedb4cd008655@mail.gmail.com>
Subject: Re: [PATCH] Re: spitz: add gpio button support (fixes regression)
To: Stanislav Brabec <utx@penguin.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@osdl.org>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com, omegamoon@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 6:22 AM, Stanislav Brabec <utx@penguin.cz> wrote:
> Russell King - ARM Linux wrote:
>> I'm not sure we want to apply this patch - it has UTF <U+FEFF>
>> sequences embedded randomly in it.

That's ZWNBSP - Zero-Width No-Break Space (unicode character FEFF).
I think Stanislav needs to train his evolution a little bit for this.

Anyway, applied to 'fix' with the above special character removed.
