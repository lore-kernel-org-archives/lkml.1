Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638Ab0ATKnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0ATKnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930Ab0ATKnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:43:22 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36938 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0ATKnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gRwXEmJEOgzA+zs/fDVNBraNTws0EaIj8Afp2mBR+2qpWyW77bYO7eOuohCqD/ei3a
         f5zONHPv9EBYErimWkr8pCCnVh7of8M3uOOSuM3kxFGvhlDIfAUlK0/4xMl38bD4YEXb
         qLrIiaYjyOBrOo/JRVUXvKuUM7FdIgCqXNYAo=
MIME-Version: 1.0
In-Reply-To: <4B56A8A0.3050309@gmail.com>
References: <20100116235653.898098245@gmail.com>
	 <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com>
	 <4B568C63.4050506@gmail.com>
	 <7eb6a4d81001192233i5418249ct5a1717045f75167c@mail.gmail.com>
	 <4B56A8A0.3050309@gmail.com>
Date: Wed, 20 Jan 2010 11:43:17 +0100
Message-ID: <7eb6a4d81001200243k7ca637cco25d319a43edf86f5@mail.gmail.com>
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA 
	write
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       juergen.metzdorf@telelev-dsl.de, markpschool@hotmail.com,
       sporadic.crash@gmail.com, apopov@sirma.bg, david@coomber.co.za,
       jay4mail@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/1/20 Tejun Heo <htejun@gmail.com>:
> Hello,
>
> On 01/20/2010 03:33 PM, Bart Hartgers wrote:
>> Well, the ata_sff_pause actually does a ndelay(400), and with today's
>> processors that would be a 'slow path', right?
>
> unlikely() is used to mark very unlikely paths not the slow ones and I
> don't really think DMA_TO_DEVICE would qualify as an unlikely path.
>

Ok, I am convinced; I'll drop the unlikely.

Groeten,
Bart

> Thanks.
>
> --
> tejun
>



-- 
Bart Hartgers - New e-mail: bart.hartgers@gmail.com
