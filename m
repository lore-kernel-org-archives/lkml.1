Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0AaXR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:17:27 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39308 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab0AaXRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:17:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K38Fxd8xAyPocJzojMrkbhYLuxsvcVYhpl36FKotGjrSGfGJ+C3AgpbpiEu4vvU8Bt
         IpJZ4H/UzC7QIK6YhzgJjPfLn3RgDTT/4/FLV4Za2Vlqoq4bP1wn2MO3XmQM2O4csak9
         iaN5jrfiRM3CCmI0mNzDFAeHIPQPbimXEaHsI=
MIME-Version: 1.0
In-Reply-To: <20091016132730.GA5731@elte.hu>
References: <817ecb6f0910151625o7eb645e8pff574a2c12bdb763@mail.gmail.com>
	 <20091016064433.GC20388@elte.hu>
	 <817ecb6f0910160622m68486be7ifeb56b43921fc7c1@mail.gmail.com>
	 <20091016132730.GA5731@elte.hu>
Date: Sun, 31 Jan 2010 18:17:24 -0500
Message-ID: <817ecb6f1001311517v56485679s987430c41e3f20f3@mail.gmail.com>
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

On Fri, Oct 16, 2009 at 8:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
[...]
> Well, if we are going to touch this area i'd like to see them addressed
> together.
>
> The 1MB thing would obviously be a default-off Kconfig option so in that
> sense it should not break anything by default.

Ingo,

I've got this 1MB thing fixed. I have also adjusted my previous
patches to be compatible with 2.6.33-rc5.
I will be re-posting this patch set to LKML shortly.
Let me know if there is anything else you would like me to adjust.

Thanks.
