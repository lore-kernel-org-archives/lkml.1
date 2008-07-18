Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbYGRRqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbYGRRqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYGRRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:45:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:43253 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYGRRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B/o6ekRBJCxrXHltPuKyE5UH/fRLi/itGNhMdxzCFC+va0P4g+ZAC7jkKX76hAdJtl
         e3b3bbMzE7XTNbcEZRaa/ptvF1iH20L4MFVmh/JIzDv37O28JEOOP/zD8iV2LglgmP0u
         8zat5jt0Es1DuCBBF5l+v6Egs1xdHsn90frLg=
Message-ID: <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com>
Date: Fri, 18 Jul 2008 19:45:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: warn on apic error
Cc: "Ingo Molnar" <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080718174413.GD6897@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718172821.GA4149@localhost.localdomain>
	 <20080718174413.GD6897@asus>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 7:44 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Vegard Nossum - Fri, Jul 18, 2008 at 07:28:21PM +0200]
> | From e89f2a9f33d01a2df7553b63cb1df525c6e75ad4 Mon Sep 17 00:00:00 2001
> | From: Vegard Nossum <vegard.nossum@gmail.com>
> | Date: Fri, 18 Jul 2008 19:14:06 +0200
> | Subject: [PATCH] x86: warn on apic error
> |
> | There are certain APIC errors which are obviously programmer errors,
> | e.g. writing to illegal APIC registers, or sending invalid interrupt
> | vectors. Since the error interrupt happens spot on the erroneous code,
> | we might as well make a bit of noise about it and display the stack-
> | trace.

> Hi Vegard, i think you better should use  #APIC_ESR_... macroses
> from apicdef.h instead of hardcoded bits.

OOps. I actually had this in my commit message, but it disappeared mysteriously:

    In particular, the errors we do this for are:

    - Send CS error
    - Send accept error
    - Send illegal vector
    - Illegal register address

    (The error codes are listed in a comment just above the code in
    question.)

But if these definitions exist, then I will use them. Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
