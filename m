Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZHYJb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZHYJb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZHYJbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:31:24 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41088 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZHYJbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=v1cmz9u2HIfE7OeP2KqRhq93lpEKjOl5X5EfjRmRSK2iX9f15gjMIn/ZrPXIFLoauo
         BttE2hedHf3e+mxGCfe6dt5HObHpj4/zLA8ZTn56NM9UrYY4cgy8eWFluBQScDR6KZmL
         BGJBFsKvs+X37T4MWnIjii63wwlxL6lbRbwHU=
MIME-Version: 1.0
In-Reply-To: <1251192534.15678.29.camel@pc1117.cambridge.arm.com>
References: <20090825071959.GA25877@elte.hu> <20090825083222.GC17692@elte.hu>
	 <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu>
	 <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191507.26351.0.camel@penberg-laptop>
	 <1251192069.15678.21.camel@pc1117.cambridge.arm.com>
	 <1251192415.26351.5.camel@penberg-laptop>
	 <1251192534.15678.29.camel@pc1117.cambridge.arm.com>
Date: Tue, 25 Aug 2009 12:31:24 +0300
X-Google-Sender-Auth: 0dead6bb85948d8c
Message-ID: <84144f020908250231k30ff4e9do20856bd1291f418c@mail.gmail.com>
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized memory 
	(f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 12:28 PM, Catalin
Marinas<catalin.marinas@arm.com> wrote:
>> Does this look OK to you?
>
> For the kmemleak.c part:
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Vegard? Ingo? The patch is based on tip/out-of-tree so it probably
should go to the kmemleak tree?

                                 Pekka
