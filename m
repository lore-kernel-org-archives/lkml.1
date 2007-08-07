Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbXHGANk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbXHGANk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 20:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbXHGANd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 20:13:33 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:22374 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbXHGANc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 20:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VYw6l1pl5hMbUeyX009zsxT/QlyB0bmjOT+pLzumJFGFWIVDodD3CWXahVFVkTuD27dRp/Mg8D9oFNRWnExfEVcnPuaKrbFgMQ59DPjgg1BFXCNJ1C17OuaxvPMIsTKi61stfjW7P9N3qovjHWZtzyIorKugLSnmJlP5O9aMR8o=
Message-ID: <8bd0f97a0708061713y75651621u8b2e57b1be5a61c8@mail.gmail.com>
Date: Mon, 6 Aug 2007 20:13:30 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] remove strict ansi check from __u64 in asm/types.h
Cc: "Olaf Hering" <olh@suse.de>, linux-kernel@vger.kernel.org,
       "Michael Matz" <matz@suse.de>
In-Reply-To: <46B75D3B.6080101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806172331.GA8102@suse.de> <46B75D3B.6080101@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Olaf Hering wrote:
> >
> > Remove the __STRICT_ANSI__ check from the __u64/__s64 declaration on
> > 32bit targets.
> >
> > Here is the reason why we think the check should be relaxed:
>
> I think the fact that "long long" was made official C in C99 is good
> enough.  Flagging them as __extension__ is okay, I guess, but something
> like this should definitely go in.

the patch we (Gentoo) tried posting a while ago never saw any response:
http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo/src/patchsets/gentoo-headers/2.6.22/35_all_c99-types.patch?rev=1.2
-mike
