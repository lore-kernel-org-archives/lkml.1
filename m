Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZK2Vjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZK2Vjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZK2Vja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:39:30 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:65502 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZK2Vja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:39:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lFQSt8EjZDoCQC9TTWaLQLPnnxBj4/ce7iuColmhUUPhDk7EsIRLwtFynLXfLajMAP
         9D/3MeqRsb4vpzSBiE0fRGQ7Zxfkh/NGRcJ0L4nxIvWZ7OYd4ehSTIQo1vMCTJ8Piumr
         3Y6Lficl8LDWku0b+3KBqu48pF5XX5JABSFjA=
MIME-Version: 1.0
In-Reply-To: <20091125144307.5e7d6d6f.akpm@linux-foundation.org>
References: <1259162390-378-1-git-send-email-cliffcai.sh@gmail.com> 
	<20091125140422.cdee4a0d.akpm@linux-foundation.org> <8bd0f97a0911251425q178993fete79b675e2730bdec@mail.gmail.com> 
	<20091125144307.5e7d6d6f.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 29 Nov 2009 16:39:16 -0500
Message-ID: <8bd0f97a0911291339v7b0195dfjeb2065d011b47dc7@mail.gmail.com>
Subject: Re: [PATCH v4][mmc/host]:Blackfin SD Host Controller Driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cliffcai.sh@gmail.com, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, cliff.cai@analog.com,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 17:43, Andrew Morton wrote:
> On Wed, 25 Nov 2009 17:25:20 -0500 Mike Frysinger wrote:
>> > Arguably wrong from a coding-style POV and looks weird IMO. __Adds a bit
>> > of risk that subsequent coders will think they're writing in python adn
>> > will add bugs.
>>
>> i dont really get what you're referring to here.  the code in question
>> looks ifne to me, and i dont see anything "python-esque" about it
>
> Code like
>
>        if (expr) {
>                line1;
>                line2;
>        } else
>                line3;
>
> looks odd and can cause people to later add bugs along the lines of
>
>        if (expr) {
>                line1;
>                line2;
>        } else
> +               line3a;
>                line3;
>
> this is particularly the case if line3 is long, or is preceded by a
> comment.  This has happened in the past.
>
> Adding the missing braces reduces the risk that this will occur.

*shrug* people can screw up braces regardless of how many statements
and/or branches there are.  i doubt people are going to get confused
and think kernel code is python, but if you really want to be pedantic
about braces, doesnt matter that much to me.
-mike
