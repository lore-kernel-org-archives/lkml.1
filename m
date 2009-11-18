Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbZKRTRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbZKRTRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932602AbZKRTRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:17:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57788 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbZKRTRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=dFUzi4MhTu5+oWCq+vI+nDn1LjyJnRB8RKLukJN6mGLnaifn9SYn2FLQkBxaGJZkPh
         NDk16LGw8jO4EgkhA8sDJR3ujOurPZYSHVd6IXZJ35DsqXeVYeAa4BkDsk/UwKVRnEhG
         yUZcbtgJwzRPVcKHNDJYDx7tP5rcwCKnqJOho=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Wed, 18 Nov 2009 20:16:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <20091118184125.623e063d@lxorguk.ukuu.org.uk> <4B04413D.30302@ru.mvista.com>
In-Reply-To: <4B04413D.30302@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <200911182016.36720.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009 19:47:25 Sergei Shtylyov wrote:
> Hello.
> 
> Alan Cox wrote:
> 
>   >>Having separate drivers wasn't the best decisions from the maintainability
> >>point-of-view.   It added needless complexity (different chips share the same
> 
> > It was most definitely a good decision, having maintained both sets of
> 
>     Separating HPT36x was grounded enough decision but I can't say the same 
> of the separation of HPT3xxN.

When it comes to HPT36x I would agree if we would be developing completely
from scratch but due to historical reasons we share UDMA blacklists between
HPT36x and HPT37x.  It is not worth it in terms of potential regressions to
try to untangle them nowadays.

> > drivers at different times. It also makes it possible to do things the
> > way highpoint does
> 
>     Oh, don't remind me of that stupid code mostly not worth copying from...
> 
> >>PCI IDs which make detection across multiple drivers extremely painful) and
> >>confusion (i.e. would you have guessed that HPT302 is supported by pata_hpt37x
> >>while HPT302N by pata_hpt3x2n?).
> 
>     How about HPT371N? ;-)

Not a problem, this one is unsupported according to help entries. ;)

-- 
Bartlomiej Zolnierkiewicz
