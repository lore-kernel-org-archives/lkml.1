Return-Path: <linux-kernel-owner+w=401wt.eu-S964982AbXBEWeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbXBEWeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964937AbXBEWeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:34:00 -0500
Received: from raven.upol.cz ([158.194.120.4]:46188 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982AbXBEWd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:33:59 -0500
Date: Mon, 5 Feb 2007 23:42:35 +0100
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Allen Martin <AMartin@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Nvidia cable detection problems & ACPI (beware, slight off-top)
Message-ID: <20070205224235.GB28048@flower.upol.cz>
References: <45C72012.7050605@gmail.com> <20070205132247.6f611e3c@localhost.localdomain> <45C73A3E.6080700@gmail.com> <20070205143439.6962c076@localhost.localdomain> <45C7444F.4070500@gmail.com> <58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com> <DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com> <E1HEB7U-0007IH-FV@flower> <20070205220442.6e13a7b6@localhost.localdomain> <45C7A7D0.407@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C7A7D0.407@garzik.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(i don't know a single bit of details of what i'm writing, so... ;)

Jeff Garzik wrote:
> Alan wrote:
> >>I'm very upset, that hardware nvidia-lego forces system software (and
> >>programmers) to know "unfortunately no standard" ways of desinging
> >>things... One read-only-for-os, hardware set bit in kind of control
> >
> >The hardware doesn't. The BIOS authors do by not setting the cable flags.
> >We actually need to use the STM and GTM methods for PC suspend/resume so
> >it makes sense to see if they will work out in this case too.

Before that. I mean, to let Vendor to choose (and software operate) GPIO
and then to have headache, you've described. Also, here i'm not going
wider, than hardware cabel detection/max speed test (IMHO it must be
pretty easy).

> We also need ACPI, where available, because that's the only way to 
> obtain a BIOS-set hard drive password.

Plain-text passwords -- i don't actually know, if they are useful at all.
What if BIOS has admin/user passwords set?
(kernel: if you have BIOS password, press RESET; if you don't press POWER ;)

> And BIOS vendors often deliver hard drive-specific errata this way, if
> the problem is serious enough (though certainly we would prefer that
> the OS knows about drive errata, when a runtime patch is necessary)

I thought versions, revisions, stepping are indicators of that, and
OS have workarounds, fixes, optimizations, based on that kind of
information. "BIOS vendors", as i read here, are IMHO -bug-in-the-middle-
attack (:


Kind regards, guys.

--
-o--=O`C
 #oo'L O
<___=E M
