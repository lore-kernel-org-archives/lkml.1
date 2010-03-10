Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0CJCrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 21:47:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52654 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab0CJCrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 21:47:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ld/TkggbMrI39M42DGGxkBpDfyoYRoG4dPV1hYWGdMkr90qqMF2D4AksIBKACk4Ztu
         VSM4CPt/psEeZULUQ53ZlWYXL/Y1IyEFbC2MI1i2gm7CpKDygkJTOfwVEcWyr3BE1izN
         m5qrbr4nLfWC8yWWcWXhP+UUuw3bJYW13yUDI=
MIME-Version: 1.0
In-Reply-To: <1267633569.1947.23.camel@work-vm>
References: <4B8B901E.4050302@ladisch.de>
	 <4b8c226e.0aa1660a.67e2.6fdc@mx.google.com>
	 <1f1b08da1003011259yed7c61bvb18071eb8e465bca@mail.gmail.com>
	 <be233a491003030107u3d9fae9cvc6b4a25db7060ec9@mail.gmail.com>
	 <1267633569.1947.23.camel@work-vm>
Date: Tue, 9 Mar 2010 18:47:19 -0800
Message-ID: <be233a491003091847s50e7d995qe090902c460cb8af@mail.gmail.com>
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 8:26 AM, john stultz <johnstul@us.ibm.com> wrote:
> Oh, right. Sorry about that, Glibc still hasn't picked these up.
>
> I'll have to chase down how to get that done.
>
> For now, you can just add the following to your code:
> #define CLOCK_MONOTONIC_RAW             4

Ah, thanks. Tried it out and it works how I needed. A sad omission
that this concept wasn't included in the original POSIX clockids. I
previously read a reference to the _RAW version but gave up when it
didn't seem to be present according to time.h.
