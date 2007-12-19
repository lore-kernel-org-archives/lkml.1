Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXLSRJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXLSRJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbXLSRJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:09:36 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:51246 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXLSRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:09:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JJwQhOYNCgUgRCfjS0Vp5EHnacsozzkn5Km2VtMlVDn8/ZtrQmRQHCI+IYbm1eeSL0ePxZ8SBxef66kfPmzTADT6rrWjNnY+QGFr0FDX+Z2aWhB1IS7En9l7CuzNa9lpdz11xRfNqKjNLcyuCR1vDb4Q/QYxEJOvBUxehhpGbps=
Message-ID: <82e4877d0712190909y6b449e0cgee3ba7363cd5e85b@mail.gmail.com>
Date: Wed, 19 Dec 2007 12:09:33 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20071219170631.GA18353@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
	 <20071219104823.GI3521@elte.hu>
	 <82e4877d0712190848r4168b3dp80e53fdcd7c82ce5@mail.gmail.com>
	 <20071219165420.GA15291@elte.hu>
	 <82e4877d0712190900y17670831k51429996f78e954a@mail.gmail.com>
	 <20071219170631.GA18353@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2007 12:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
>
> > Here is the right one -
> > 2.6.24-rc5  is without patch, 2.6.24-rc5-new is with patch.
>
> >  DMI present.
> > -dmi_save_oem_strings_devices: out of memory.
> > -dmi_string: out of memory.
>
> ok. I guess absent a real regression/bug reported by someone who gets
> these messages, we can do your patches in 2.6.25. DMI stuff is quite
> hardware dependent so it's hard to get the code tested well.
>

Yep, I agree.

Andrew if you want to keep it in -mm till 2.6.25 - that'd hopefully
give it some testing.

Parag
