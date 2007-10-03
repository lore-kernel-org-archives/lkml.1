Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbXJCSsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbXJCSsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbXJCSsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:48:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:32865 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbXJCSsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=X5QOuLVWbWQRncb7QM56ihUruKQzcnKwlAxhm4cbHBKJrnl82mOPS67jY59hgZ/A+5icxnvKTbMA4J5SSE3VvQfJHf0gsfFOdiywNaiCMTxDQtj/0RzOUr/p+JEL/58bj0ZR7A2XjbedIi+L75gaIMewQEhUzUN/6E8LiXm7Jcs=
Message-ID: <84144f020710031148i346b393bm528fc150fedff00f@mail.gmail.com>
Date: Wed, 3 Oct 2007 21:48:34 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Neil Romig" <neil@romig.demon.co.uk>
Subject: Re: File corruption when using kernels 2.6.18+
Cc: linux-kernel@vger.kernel.org, hyoshiok@miraclelinux.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <4703E287.3070705@romig.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FFC371.9040805@romig.demon.co.uk>
	 <84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com>
	 <4702B28F.5050404@romig.demon.co.uk>
	 <84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
	 <4703E287.3070705@romig.demon.co.uk>
X-Google-Sender-Auth: 4ec77f102e98d0cd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 10/3/07, Neil Romig <neil@romig.demon.co.uk> wrote:
> > > Thanks for your help on this. I have narrowed it down to commit
> > > "c22ce143d15eb288543fe9873e1c5ac1c01b69a1 x86: cache pollution aware
> > > __copy_from_user_ll()". This fits with the errors I'm getting, so now I need
> > > to find out if I can safely ignore this patch, or does it have to be modified?
> > > This is my first Linux bug in many years of simply using it, so I'm a little
> > > nervous!

A some point in time, I wrote:
> > Just to make sure, if you disable CONFIG_X86_INTEL_USERCOPY, the
> > corruption goes away?

On 10/3/07, Neil Romig <neil@romig.demon.co.uk> wrote:
> It took some fiddling to disable (edit arch/i386/Kconfig.cpu) but that has fixed it.
> Many thanks!
>
> Does this need to be reported as a bug? Or should the kernel config scripts be
> changed to enable this option to be easily turned off?

Looks like a bug to me. Can we have your /proc/cpuinfo too?

                              Pekka
