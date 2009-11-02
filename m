Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZKBD1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZKBD1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 22:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZKBD1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 22:27:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:40321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZKBD1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 22:27:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ez1ySj8tvfYec/HFCUvctnm62N9HNPbMzhe8P2JHuJrMV2tBxqPE5svkKpuIIrswl9
         Mq8r7oM5hw+gwucwsKMW/ycYZf2H4O+yUEjuDYm8/oM7esrEH+hLey0l9OOBAvFHxUM4
         J0Q6MZ3zsaHKkUoTV9eUzs1BZBL/OESvkBYZc=
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.1.10.0911012017450.55434@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	 <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	 <alpine.OSX.1.10.0911011540400.53392@caridad.local>
	 <yw1xhbte0wx0.fsf@unicorn.mansr.com>
	 <73a01bf20911011408v5b6d335fj46c893a8e7d26ab4@mail.gmail.com>
	 <alpine.OSX.1.10.0911012017450.55434@caridad.local>
Date: Sun, 1 Nov 2009 22:27:42 -0500
Message-ID: <73a01bf20911011927o717e5843r1f21099be791d634@mail.gmail.com>
Subject: Re: FatELF patches...
From: Rayson Ho <raysonlogin@gmail.com>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 1, 2009 at 8:17 PM, Ryan C. Gordon <icculus@icculus.org> wrote:
> I'm tracking down a lawyer to discuss the issue. I'm surprised there
> aren't a few hanging around here, honestly. I sent a request in to the
> SFLC, and if that doesn't pan out, I'll dig for coins in my car seat to
> pay a lawyer for a few hours of her time.

Good!! And thanks :)

And is the lawyer specialized in patent laws??


> I've had about a million people point out the boot loader thing. There's
> an x86/amd64 forest if you can see past the MIPS trees.

If it's x86 vs. AMD64, then the installer can already do most of the
work, and it can ask the user to insert the right 2nd/3rd/etc CD/DVD.


> Theoretical ones become practical
> the moment someone decides to roll out a company-internal distribution
> that works on all the workstations inside IBM or Google or whatever...even
> if Fedora would turn their nose up at the idea for a general-purpose
> release.

Don't you think that taking a CD/DVD to each workstation and start the
installation or upgrade is so old school??

Software updates inside those companies are done via the internet
network, and it does not matter whether the DVD can handle all the
architectures or not.

And the idea of a general-purpose release might not work. As 90% of
the users are using a single architecture (I count AMD64 as x86 with
"some" extensions...), we won't get the benefits so having the extra
code in the kernel and the userspace. Most of the shipped commercial
binaries will be x86 anyways -- and as Alan stated, the packaging
system is already doing most of the work for us already (I don't
recall providing anything except the package name when I do apt-get).

For embedded systems, they wanted to take away all the fat more than
shipping a single app.


> These are concerns, too, but the kernel has been, in my experience, very
> good at binary compatibility with user space back as far as I can
> remember. glibc has had some painful progress, but since NPTL stabilized a
> long time ago, even this hasn't been bad at all.
>
> Certainly one has to be careful--I would even use the word diligent--to
> maintain binary compatibility, but this was much more of a hurting for
> application developers a decade ago.

The kernel part refers to kernel modules.

But yes, binary compatibility was a real pain when I "really" (played
with it in 1995, didn't really like it at that time) started using
Linux in 1997. However, I think the installer/package manager took out
most of the burden.

Rayson



>
> At least, that's been my experience.
>
> --ryan.
>
>
>
