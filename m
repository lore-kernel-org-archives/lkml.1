Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZFKNMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZFKNMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFKNMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:12:41 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36403 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZFKNMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nyYkaUrEcEP4en5qyoT3/gTbTz8YfhV93O3DiVNMh5ZTt7GtxJyejfJMdcAAGE1Taa
         VcEQjMI+JbNpsU/HfRaBVkxqdOWhSz8CGUHaSBMbMlruJnaZjSPIJryMMhH2cUEM1V1s
         SxVtqLGZAiuF8OhXp9c5Ip7cBMx2htqE8qDpU=
MIME-Version: 1.0
In-Reply-To: <a4423d670906110603s42bf0287p848b00c2cc786cc1@mail.gmail.com>
References: <a4423d670906110603s42bf0287p848b00c2cc786cc1@mail.gmail.com>
Date: Thu, 11 Jun 2009 16:12:41 +0300
X-Google-Sender-Auth: 7dd28f42989f7d30
Message-ID: <84144f020906110612t3102efdev39e77b6429013176@mail.gmail.com>
Subject: Re: next-20090611: SLUB: Unable to allocate memory on node -1
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 4:03 PM, Alexander
Beregalov<a.beregalov@gmail.com> wrote:
> Hi

There should be a stack trace here printed out by the page allocator.
Can you post that too?

> SLUB: Unable to allocate memory on node -1 (gfp=11200)
>  cache: kmalloc-2048, object size: 2048, buffer size: 2048, default
> order: 3, min order: 0
>  node 0: slabs: 407, objs: 1724, free: 0
> SLUB: Unable to allocate memory on node -1 (gfp=11200)
>  cache: kmalloc-2048, object size: 2048, buffer size: 2048, default
> order: 3, min order: 0
>  node 0: slabs: 407, objs: 1724, free: 0
>
> It is 4-way (2*2) SMP with 2Gb RAM
