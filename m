Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZE0Cth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZE0Cth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZE0Cta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:49:30 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:37003 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbZE0Ct3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jQdQOHuadD2xxJ053f3fv1n1p+5wgK1LPPGrJ0y/GQh82Gv77kyC3zpt37c3/HiN/k
         NbeMIsgMv7wMS4xrd8QLjvC7qbcWqtObDSz8T2kSD7wwUx4ZyU+0q/s1fubVXAHGdvta
         UACWUauHd4d75kZrw0EjajpBJ1heYlWBUhUtk=
MIME-Version: 1.0
In-Reply-To: <86802c440905251911h6f6c146eo4c30d306ac8d17d8@mail.gmail.com>
References: <b9df5fa10905251820l3783327ek4f6b7014aa167690@mail.gmail.com>
	 <86802c440905251911h6f6c146eo4c30d306ac8d17d8@mail.gmail.com>
Date: Wed, 27 May 2009 08:49:31 +0600
Message-ID: <b9df5fa10905261949j3eb4dc9ft321dba3c46c335db@mail.gmail.com>
Subject: Re: [PATCH] v2: x86,APIC: Detect lapic_is_integrated() once - use on 
	and on
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, macro@linux-mips.org,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/09, Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> do you need to call lapic_is_integrated() for 32bit smp?

 Actually, external APIC were used in older version of intel
processors ( probably some P4 and it's earlier version - if i'm not
wrong). So I don't think it's  required. And current implementation
doesn't separate the case of smp or non-smp - it just deals with 32 or
64 bit processors. Is there anything that i'm missing ?

Thanks,
>
> YH
>
