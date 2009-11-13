Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZKMAll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZKMAll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 19:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZKMAlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 19:41:39 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:62405 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZKMAli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 19:41:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CgbkTB6qSBDf5Xv5dFruPbIFZKg3NkyXkGTfxWho99fAVk9Fqb/0Mi7JXj5wNVUw7X
         foMQU0aOoZhjhpXfpvJMSGwrqUacDEP1uOFuUWLGkbcVg/g8g41AqHu40R6sqp3tY0zb
         AqpKewFg4x0GRbMEp+E7ywChcYnjFZbBC7TFY=
MIME-Version: 1.0
In-Reply-To: <4AFCA75C.8000101@pobox.com>
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
	 <4AF8F363.3010806@rtr.ca> <200911101651.24912.bzolnier@gmail.com>
	 <84144f020911100808y55f5bfa2v5c203b356583a7b5@mail.gmail.com>
	 <4AFB3C9D.4020609@rtr.ca>
	 <a4c8a6d00911111450y7e451071h3f0ede0a1003678b@mail.gmail.com>
	 <4AFC9FEC.8030304@rtr.ca> <4AFCA75C.8000101@pobox.com>
Date: Thu, 12 Nov 2009 22:41:42 -0200
Message-ID: <a4c8a6d00911121641k13288cb3s696a876901c68eb3@mail.gmail.com>
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
From: Thiago Farina <tfransosi@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <liml@rtr.ca>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, mlord@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 10:25 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 11/12/2009 06:53 PM, Mark Lord wrote:
>>
>> Thiago Farina wrote:
>>>
>>> On Wed, Nov 11, 2009 at 8:37 PM, Mark Lord <liml@rtr.ca> wrote:
>>>>
>>>> Looks like unnecessary churn and obfuscation to me.
>>>
>>> Obfuscation? Are you saying that just because you wrote this code? So
>>> what is the usage of a macro? I think you are having a defensive
>>> position here.
>>
>> ..
>>
>> No, actually I believe Jeff wrote that particular line of code.
>
> You know, Linus actually invented a command for people who enjoy this
> game...  ;)
>
>        git blame drivers/ata/sata_mv.c
>
> shows each line of code, and metadata about each line such as commit id and
> author name.

Sure, and I ran this command before saying that Mark wrote this code.
