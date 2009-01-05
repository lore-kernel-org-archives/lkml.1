Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZAECYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZAECYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZAECX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:23:58 -0500
Received: from mail2.shareable.org ([80.68.89.115]:47257 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZAECX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:23:57 -0500
Date: Mon, 5 Jan 2009 02:23:49 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Rob Landley <rob@landley.net>, Valdis.Kletnieks@vt.edu,
       Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Message-ID: <20090105022349.GB1345@shareable.org>
References: <200901020207.30359.rob@landley.net> <200901031936.04642.rob@landley.net> <25035.1231045675@turing-police.cc.vt.edu> <200901040043.08577.rob@landley.net> <20090104221356.GA32357@shareable.org> <1231114530.3310.6.camel@gimli.at.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231114530.3310.6.camel@gimli.at.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> > (I have 850 Linux boxes on my network with a bourne shell which
> > doesn't do $((...)).  I won't be building kernels on them though :-)
> 
> Believe it or not, but there are folks out there who build the firmware
> on ARM 200 MHz NFS-mounted systems natively  (and not simply
> cross-compile it on a 2GHz PC .....).

Really?

My 850 Linux boxes are 166MHz ARMs and occasionally NFS-mounted.
Their /bin/sh does not do $((...)), and Bash is not there at all.

If I were installing GCC natively on them, I'd install GNU Make and a
proper shell while I were at it.  But I don't know if Bash works
properly without fork()* - or even if GCC does :-)

Perl might be hard, as shared libraries aren't supported by the
toolchain which targets my ARMs* and Perl likes its loadable modules.

I'm not sure why I would want to build a kernel on these devices.

But I see why people with mobile ARM devices like gphones might
want to, when they're out travelling.

-- Jamie

(* - No MMU on some ARMs, but I'm working on ARM FDPIC-ELF to add
     proper shared libs.  Feel free to fund this :-)
