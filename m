Return-Path: <linux-kernel-owner+w=401wt.eu-S934598AbXEHM1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598AbXEHM1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934430AbXEHM1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:27:21 -0400
Received: from ns.suse.de ([195.135.220.2]:36681 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934515AbXEHM1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:27:20 -0400
From: Andi Kleen <ak@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Date: Tue, 8 May 2007 14:27:08 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       lkml <linux-kernel@vger.kernel.org>
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <46405E0C.3020909@zytor.com>
In-Reply-To: <46405E0C.3020909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705081427.08646.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2007 13:25, H. Peter Anvin wrote:
> Andrew Morton wrote:
> >>  	# Normalize the start address
> >> -	jmpl	$BOOTSEG, $start2
> >> +	jmpw	$BOOTSEG, $start2
> >
> > Sigh, another blow struck in the ongoing struggle between my Vaio and the
> > rest of the world.
> >
> > Stone-cold black-screen lockup immediately upon boot.
> >
> > Stock FC5 install, config at
> > http://userweb.kernel.org/~akpm/config-sony.txt
>
> Andrew, I'm seriously starting to think there is something fundamentally
> wrong with that test setup.

I agree. The patch above does not change any code in the running
kernel and is not even used in a normal kernel boot. Andrew,
can you please double check that?

> [*] On the other hand, as I discovered in the process,
> arch/i386/kernel/cpu/transmeta.c apparently gets miscompiled on my
> development system for top-of-Linus.  This is a Linux bug and not gcc's
> fault.  The following code:

You should have put that into a different mail (is there a electron shortage
somewhere now? @)  Ok, thanks for the well researched bug report.  Will fix in 
my tree.

-Andi

