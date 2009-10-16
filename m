Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZJPNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZJPNXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932275AbZJPNXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:23:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58239 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbZJPNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=D+2L3Ll8jPHtxbaREX7QfCB5jjRAahWe4AoQr9Gs/4J81JYTn+t6Zc3JB6AriqNBzc
         hvFM2xeef0lwThwhyVjYHwbjculvmnkIOpDFz2I2RDdJYBlSgty/btE91NG2pLul0Teu
         lbQoLrwOLBZa4ZdL0rhwGQLO76dzlIexFnwSY=
MIME-Version: 1.0
In-Reply-To: <20091016064433.GC20388@elte.hu>
References: <817ecb6f0910151625o7eb645e8pff574a2c12bdb763@mail.gmail.com>
	 <20091016064433.GC20388@elte.hu>
Date: Fri, 16 Oct 2009 09:22:37 -0400
Message-ID: <817ecb6f0910160622m68486be7ifeb56b43921fc7c1@mail.gmail.com>
Subject: Re: [PATCH V6] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks - this one looks good now.
>
> Would be nice if you could send this with the patch that also deals with
> the first 1 MB.

I do plan to have that first megabyte fixed. But for now, let's keep
these patches separate, as there are many things that rely on that 1MB
area and I want to make sure they all still work properly with the
patch.
