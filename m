Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXIRWjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXIRWjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbXIRWi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:38:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:15298 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbXIRWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HQF+3HkTDpBEATEj44X6TwbqEtha+hzqzCyeJjA3LGBt/QqpuZxIFUQSOUbTI0AtSV7Zl2lZItXQ6hpvNF1YP+llIG3+URgLe79S6ht7sx2UfFEi35KHXRIm48cAzoOgXrUHTFglDwr9rwXcBTMHPomcEOrbkc90fdjCMeXAZOM=
Message-ID: <13426df10709181538u3dfc01acwe900fcfc9d33a7e8@mail.gmail.com>
Date: Tue, 18 Sep 2007 15:38:55 -0700
From: "ron minnich" <rminnich@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [Lguest] [PATCH] Introduce "used_vectors" bitmap which can be used to reserve vectors.
Cc: "Andi Kleen" <ak@muc.de>, lguest <lguest@ozlabs.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1189746849.7262.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1189746849.7262.29.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hi Andi and everyone,
>
>         Wanted to get your thoughts on this patch.  lguest now supports plan9
> guests which use 0x40 for system calls.  We want to let the guests use
> that vector if available, but have no way to stop io_apic from
> clobbering it.  This does that, and also simplifies the current code a
> little.

I can confirm that this patch supports Plan 9 perfectly as a guest.

thanks

ron
