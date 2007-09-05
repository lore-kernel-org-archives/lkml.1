Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbXIERvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbXIERvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXIERvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:51:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:7287 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbXIERvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LseFE19K9irSfz7VQBJ4w+H5xrmb50qD+f60eb/mSxgSNHQDjxb+X/nf3Onqtgu1nxM1OHUMoPxCVSSvrfczSyLd2QSqc5cFxXkQprpa9ArRuGj660fzexkRZYAiNm1B+Ad0dP70Up0fmYSOBLLI48kp/NxKt6kkjvblbWrWtKU=
Message-ID: <8bd0f97a0709051051y1c0328ffx24068da775f8bad2@mail.gmail.com>
Date: Wed, 5 Sep 2007 13:51:10 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <8bd0f97a0709040805y233cf07yc60ec0fedadb706d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
	 <p733axyxcli.fsf@bingen.suse.de>
	 <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com>
	 <20070902065926.GA15487@one.firstfloor.org>
	 <8bd0f97a0709020815r75fcb225lf44bcb57783b436c@mail.gmail.com>
	 <20070902154351.GA21230@one.firstfloor.org>
	 <8bd0f97a0709040805y233cf07yc60ec0fedadb706d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/07, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On 9/2/07, Andi Kleen <andi@firstfloor.org> wrote:
> > On Sun, Sep 02, 2007 at 11:15:23AM -0400, Mike Frysinger wrote:
> > > there is still the ABI issue ... code written in kernel space in pure
> > > asm cannot always be compiled in userspace and work properly/the same
> >
> > Is that a blackfin weirdness?
>
> yes, Blackfin is weird in this respect due to being a no-mmu and
> wanting ELF, but i was being sufficiently general to bolster my claims
> and to leave the door open for any other port out there i'm not
> familiar with and any port that comes along

actually, there was another case i was thinking of ... it isnt
uncommon for architectures to use compiler flags which affect the ABI
and thus make userland not a 1-to-1 test example for the kernel ...
consider the regparam stuff we use on i386
-mike
