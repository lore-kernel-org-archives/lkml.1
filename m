Return-Path: <linux-kernel-owner+w=401wt.eu-S1422751AbXBHF63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422751AbXBHF63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422763AbXBHF63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:58:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:24339 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422751AbXBHF62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RecYlRcAlAYP/SfqN3hfjcRwUmu83QFp9swZUayC/eVdosA9KL3/Hwvgj0seG5/GaYJH7k0GPVpLp+1QAcPlpLE9xGu3mU2bY4d8NBqQK0KV4c90zQLD9QJjT1IdEDkqPdMDyt3Xkkz+TdPs7KfJiqvMDpHcxJhE8RevOfpxizc=
Message-ID: <8bd0f97a0702072158r36046dd7w64a8c7b5da1a5f9a@mail.gmail.com>
Date: Thu, 8 Feb 2007 00:58:26 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: + search-a-little-harder-for-mkimage.patch
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Roman Zippel" <zippel@linux-m68k.org>, sam@ravnborg.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kai Germaschewski" <kai@germaschewski.name>
In-Reply-To: <20070208055832.GN22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
	 <Pine.LNX.4.64.0702071846180.14457@scrub.home>
	 <20070207220435.GC22699@flower.upol.cz>
	 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
	 <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
	 <20070207203047.51a95ad0.akpm@linux-foundation.org>
	 <20070208052439.GL22699@flower.upol.cz>
	 <20070207211921.1f0220a4.akpm@linux-foundation.org>
	 <20070208055832.GN22699@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> On Wed, Feb 07, 2007 at 09:19:21PM -0800, Andrew Morton wrote:
> > On Thu, 8 Feb 2007 06:24:40 +0100 Oleg Verych <olecom@flower.upol.cz> wrote:
> >
> > > If that matter, `type -path' is bashizm (BloAted SHell), and "blackbox"
> > > with "dash" (very good `sh' equivalents) will fail.
> >
> > Does the kernel presently build with that shell?
>
> build - yes, with dash being `$(shell)'. All scripts with `#!/bin/bash'
> of course use bash, example is gen_initramfs_list.sh.

which is what mkuboot.sh is using now

> Trivial shell scripts, especially for embedded archs (Blackfin is
> one, IIRC), may be easily converted.

yes, but Blackfin is no-mmu so converting the script to use POSIX
shell is pointless to us since no-mmu is not a self-hosting
environment
-mike
