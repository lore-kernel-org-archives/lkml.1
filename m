Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZB0XGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZB0XGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZB0XGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:06:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:5525 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbZB0XGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EbFxfVPBG9BSRZV/gcUSTtEonGlJoaPxiG8jNsPeCXq9RWRvZ2s8rnL4XPKs/MiHYl
         S+DGqZZ6DtXXtl4vObIDn53cYEheB7+BGgSXbwoKtHHajAKsRs2s/fSpJ7T8u9XsnIrY
         ok2OZGO2kX0ks5k8UjJMeP/Lx7NNHa9SGmvNY=
MIME-Version: 1.0
In-Reply-To: <49A86F2E.3080701@pobox.com>
References: <3aa654a40902270944h3edeadf4pc9fb7587b76d7e9e@mail.gmail.com>
	 <49A86F2E.3080701@pobox.com>
Date: Fri, 27 Feb 2009 15:06:00 -0800
Message-ID: <3aa654a40902271506j35620f1byfd04171450581f25@mail.gmail.com>
Subject: Re: DRDY ata message > 2.6.24.7-rt14, not before.
From: Avuton Olrich <avuton@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux IDE <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 2:54 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> Avuton Olrich wrote:
>>
>> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>> ata4.00: cmd 35/00:10:b0:70:75/00:00:1f:00:00/e0 tag 0 dma 8192 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>
>
> Since you are seeing generic timeouts, without additional information, I
> would guess either a problem with interrupt delivery (not uncommon in -rt
> kernels) or you need to force your drives to 1.5Gbps.
>
>        Jeff

Sure, what additional information can I give? I can do it, I just want
to try to minimize the damage :)

So:

1) I will try without -rt

2) I'm not sure if I'll get this error if the drive isn't mounted. If
I can then I will just stop it from mounting and do a bisect.

(please add more here that you need or want)
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
