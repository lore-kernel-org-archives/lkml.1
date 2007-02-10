Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXBJOZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXBJOZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbXBJOZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:25:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbXBJOZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:25:16 -0500
From: Andi Kleen <ak@suse.de>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: [PATCH] Make aout executables work again
Date: Sat, 10 Feb 2007 15:24:55 +0100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg@hydrops.han.de, dsd@gentoo.org, paulus@samba.org,
       benh@kernel.crashing.org, lethal@linux-sh.org
References: <Pine.LNX.4.64.0702092100540.3984@localhost.localdomain> <p73y7n6goey.fsf@bingen.suse.de> <82e4877d0702100550ld369c8an2982a64dcc920169@mail.gmail.com>
In-Reply-To: <82e4877d0702100550ld369c8an2982a64dcc920169@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101524.56098.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 14:50, Parag Warudkar wrote:
> > I already fixed this in a different way -- just use the stack
> > trampoline on a.out
> >
> > Can you double check
> >
> > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/aout-no-vdso
> >
> > works for you?
> 
> Is there a reason why we specifically want to make a distinction
> between binfmts having and not having VDSOs and do we want aout to
> have the possibility of NOT having VDSO when a) It used to have it
> unconditionally b) nothing special is needed in arch or common code to
> have it and c) Not letting have it requires special arch-specific
> code* ?

I mainly did it this way because it was quite a lot simpler.
I'm not worrying too much about other strange binfmts to be honest
 
> [*] I see the patch handles i386 and x86_64 - but I am not sure if
> something similar will be needed for the other arches to allow aout
> executables in absence of VDSO (powerpc, sh).

Neither powerpc nor sh support a.out.

-Andi
