Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZFGSVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZFGSVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 14:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZFGSVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 14:21:11 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64628 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZFGSVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 14:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VFdwa3FkeqxDQTxErqcevvzHxRdePnWjdxyGB1sr1aB9WQRpQ+bkWDKSX743MkdOpP
         7R7ClFMGPJ6Gn+7zc05R2pMJKbWRQeGp26hVaAzQFRjixBYo1b0aWpCHHSaSk7XoBJv/
         x6NA2nijwa6KIwHN2kB01vr0OJv2q7+TXsDd4=
MIME-Version: 1.0
In-Reply-To: <200906071955.42378.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	 <200906071744.23629.bzolnier@gmail.com>
	 <84144f020906070954p54cdfee4y62a51795be10b0d0@mail.gmail.com>
	 <200906071955.42378.bzolnier@gmail.com>
Date: Sun, 7 Jun 2009 21:21:11 +0300
X-Google-Sender-Auth: d9ab14bf1b9e7103
Message-ID: <84144f020906071121k34d6d555i6332d49b0db0fac6@mail.gmail.com>
Subject: Re: [git pull] IDE fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Sun, Jun 7, 2009 at 8:55 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Sunday 07 June 2009 18:54:08 Pekka Enberg wrote:
>> Hi Bartlomiej,
>>
>> On Sun, Jun 7, 2009 at 6:44 PM, Bartlomiej Zolnierkiewicz
>> <bzolnier@gmail.com> wrote:
>> > Honestly, this should be solved on technical basis by somebody posting
>> > needed libata patches instead of attempts to slow down IDE fixes.
>>
>> Nobody is "slowing down" IDE fixes here. Linus explicitly said that
>> -rc8 is the last release candidate and the next one is going to be
>> -final. There's absolutely _no way_ this series is appropriate at the
>> very end of a release cycle.
>
> My honest opinion is that it is as appropriate now as it will be 2.6.31.
>
> [ I'm still amazed by the amount of *completely* bogus reasons given for
>  not merging it. ]

I don't consider this a bogus reason at all:

 10 files changed, 134 insertions(+), 43 deletions(-)

Just search the LKML archives for the amount of crap other subsystem
maintainers have gotten from Linus when they've tried to sneak
something like that after -rc4 or so.

                        Pekka
