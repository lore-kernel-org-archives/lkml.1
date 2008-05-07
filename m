Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYEGOZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYEGOZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYEGOYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:24:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:31415 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbYEGOYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i+ToBSXVEqXvDkXPrUi9GSqsD1jDT7ikX8IbueTc1IhyvK6ohlqEmbBKMCMAkPP2XXJJVPoOy8CVRnwdNTi21Fh/x/7ghLYbwZ+f7UFJvmD8X49Mi5KJDsFTVJK5bVseniyAzIYd55jkEuy7Rnv2nsmztheYgXUm/jx3VYIOIWQ=
Message-ID: <7c86c4470805070724v793fbdcamf18579308a183a9d@mail.gmail.com>
Date: Wed, 7 May 2008 16:24:49 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] perfmon: add context switch hooks for x86
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de
In-Reply-To: <4821BA06.9020704@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470805070133q29515056s386c137f644b7f3b@mail.gmail.com>
	 <4821BA06.9020704@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

It would be much bigger because it would pull in a bunch of generic
and model-specific
data structures and code.

To context switch, you need to know what the registers are, thus you
need the PMU
mapping table, which is implemented by a kernel module, so it needs
its registration
framework....


On Wed, May 7, 2008 at 4:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> stephane eranian wrote:
>  > Hello,
>  >
>  >
>  > Here is a first perfmon patch. It provides the following:
>  >
>  >    - minimal perfmon source tree layout with a topdir perfmon for
>  > generic code and
>  >      the x86 arch specific subdir in arch/x86.
>
>  How much larger would a patch be that does at least something minimally
>  useful? (like context switching the performance registers)
>
>  -Andi
>
