Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208Ab0AHG0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab0AHG0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 01:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974Ab0AHG0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 01:26:21 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:58648 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0AHG0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 01:26:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l89mXirFMZpvnpBC/QmOB857JFbzA7935niYQPp8c4nR5spkF0+u/4WUIo1V8HsbdI
         skVpQYz0weN1UetSRlr23J+MACL23SVEtrVgyl2QsvYWZ9fdMi646cESM1KUDCST4sd5
         ruxwAHmf187grcJ74B0JixZWWG4i7SoR3tm0U=
MIME-Version: 1.0
In-Reply-To: <1262931971.27700.128.camel@adam-desktop>
References: <1262925925.27700.15.camel@adam-desktop> <8bd0f97a1001072054y798833dftdb1b2a744ad52969@mail.gmail.com> 
	<1262931971.27700.128.camel@adam-desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 8 Jan 2010 01:26:00 -0500
Message-ID: <8bd0f97a1001072226x2e2391dao924675c286209143@mail.gmail.com>
Subject: Re: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
To: Li Yi <yi.li@analog.com>
Cc: Arnd Bergmann <arnd@arndb.de>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 01:26, Li Yi wrote:
> On Thu, 2010-01-07 at 23:54 -0500, Mike Frysinger wrote:
>> > @@ -60,11 +60,11 @@ static inline int atomic_add_return(int i, atomic_t
>> > *v)
>> > @@ -82,11 +82,11 @@ static inline int atomic_sub_return(int i, atomic_t
>> > *v)
>> > @@ -139,9 +139,9 @@ static inline void atomic_clear_mask(unsigned long
>> > mask, unsigned long *addr)
>>
>> looks like your mailer has line wrapping problems ... might want to
>> fix that.  maybe just find a smtp server in ADI shanghai's office to
>> send to and use sendemail.smtpersver in your ~/.gitconfig ?
>
> Thanks. Disabled auto-wrap and resend:
>
> "irqsoff" tracer may cause stack overflow on architectures using asm-generic/atomic.h, due to recursive invoking of trace_hardirqs_off().

well now you have the opposite problem ... your changelog needs to be
line wrapped
-mike
