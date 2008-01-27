Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYA0X5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYA0X5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYA0X5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:57:40 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:60027 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752211AbYA0X5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ELc/zAWtxC5PyuteDLlppE4qRozFqJWvX1Fq3MyR5EpENBMhM1MnPoLOdbbW7eTyydBxU4OPuL7sazReYqxj66iNod293OJfyUSgxzlKTLdsTRdf5G2YAl0lQT+NULBZJtFS5gAh27Tzo9QRYl1tMz9vVmJmwmTiMYPzarS6GgE=
Message-ID: <4d8e3fd30801271557i4310bc07ifbdea081001cc592@mail.gmail.com>
Date: Mon, 28 Jan 2008 00:57:36 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c - take 2
Cc: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4d8e3fd30801271448ja6a44ferbf86d37c2f3b825@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127231527.2ea40804@paolo-desktop>
	 <479D067E.3010100@gmail.com> <20080127224258.GA22018@elte.hu>
	 <4d8e3fd30801271448ja6a44ferbf86d37c2f3b825@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 11:48 PM, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> On Jan 27, 2008 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> >
> > > Looks like it would be better to proceed in the following manner:
> > >
> > > 1) remove dead code (no md5 change);
> > > 2) reformat the lines to use tabs, not spaces (no md5 change);
> > > 3) address the "else-braces" and "single statement block" errors
> > >    (no md5 change);
> > > 4) remove all unnecessary spaces (no md5 change);
> > > 5) add the KERN_ macros (md5 will change).
> > > 6) address remaining checkpatch complaints (no md5 change wrt #5
> > >    above).
> > >
> > > Each item above might get into a separate patch.
> >
> > agreed, that looks like a sensible splitup for such larger cleanup
> > patches.
> >
> > (also, a debug switch that disabled the FPU on modern CPUs and which
> > forced math-emu would be nice as well.)
>
> OK, I'll do what you both suggested.

Mmh... I wonder why if I strip the files I get the same md5sum:
paolo@paolo-desktop:~/linux-2.6/kernel$ strip
/home/paolo/Desktop/File\ punto\ o/*
paolo@paolo-desktop:~/linux-2.6/kernel$ md5sum
/home/paolo/Desktop/File\ punto\ o/*
2bf404e247edf33cf6fb99c37321cdb9  /home/paolo/Desktop/File punto o/error.o.after
2bf404e247edf33cf6fb99c37321cdb9  /home/paolo/Desktop/File punto
o/error.o.before

How should I compare the .o file?
Simply doing a md5sum or should I do a objdump -d before?
Or a strip?

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
