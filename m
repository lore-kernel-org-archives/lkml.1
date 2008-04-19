Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbYDSOfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbYDSOfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYDSOfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:35:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39078 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbYDSOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fgjh7LaQyDbyfAKVQnq8KUE3jQucIj96QXQDMVwSJeQy8mVTjnpg7bpm15fgsgqAEpJaT8WJXp4xSSXBz2j6uDKiJVPO0SxF8Oas40Ec+h0xDD+PFUbtlY+oZVlkJ+nri7L2ANavm24D5qZG3f1nDd7LajIFD1SA5lUO68L4w/Y=
Message-ID: <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
Date: Sat, 19 Apr 2008 16:35:31 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86: 4kstacks default
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>, "David Chinner" <dgc@sgi.com>,
       xfs@oss.sgi.com
In-Reply-To: <20080419142329.GA5339@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080418142934.38ce6bf4.akpm@linux-foundation.org>
	 <20080419142329.GA5339@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo!

with the older kernel is typical: xfs+nfs+4k stack(+lvm)



On 4/19/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > >  config 4KSTACKS
> > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > -	depends on DEBUG_KERNEL
> > >  	depends on X86_32
> > > +	default y
> >
> > This patch will cause kernels to crash.
>
> what mainline kernels crash and how will they crash? Fedora and other
> distros have had 4K stacks enabled for years:
>
>   $ grep 4K /boot/config-2.6.24-9.fc9
>   CONFIG_4KSTACKS=y
>
> and we've conducted tens of thousands of bootup tests with all sorts of
> drivers and kernel options enabled and have yet to see a single crash
> due to 4K stacks. So basically the kernel default just follows the
> common distro default now. (distros and users can still disable it)
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
