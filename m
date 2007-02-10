Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXBJPNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXBJPNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 10:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932590AbXBJPNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 10:13:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:34745 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbXBJPND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 10:13:03 -0500
From: Andi Kleen <ak@suse.de>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: [PATCH] Make aout executables work again
Date: Sat, 10 Feb 2007 16:12:54 +0100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg@hydrops.han.de, dsd@gentoo.org, paulus@samba.org,
       benh@kernel.crashing.org, lethal@linux-sh.org
References: <Pine.LNX.4.64.0702092100540.3984@localhost.localdomain> <200702101524.56098.ak@suse.de> <82e4877d0702100641h7b479c95mce3dfa65b0e6c779@mail.gmail.com>
In-Reply-To: <82e4877d0702100641h7b479c95mce3dfa65b0e6c779@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101612.54161.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > [*] I see the patch handles i386 and x86_64 - but I am not sure if
> > > something similar will be needed for the other arches to allow aout
> > > executables in absence of VDSO (powerpc, sh).
> >
> > Neither powerpc nor sh support a.out.
> >
> 
> Ok, that's not a concern then. Not that I care about aout but if a
> simple fix can let it have VDSO and prevent special casing, I would
> prefer to let it have VDSO and still work - at least in the interest
> of preserving existing behavior.

Ok reasonable argument.

-Andi
