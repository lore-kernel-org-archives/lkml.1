Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYCMKbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYCMKbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYCMKbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:31:42 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46307 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751794AbYCMKbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:31:41 -0400
Date: Thu, 13 Mar 2008 11:31:39 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for March 13
In-Reply-To: <20080313173506.2613be02.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0803131125010.9727@vixen.sonytel.be>
References: <20080313173506.2613be02.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Stephen Rothwell wrote:
> Status of my local build tests is at
> http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
> give advice about cross compilers/configs that work, we are always open
> to add more builds.

I noticed you added `m68k-allnoconfig', which fails because of the following
reasons:
  - There's no single CPU type enabled, hence we get:

	#define FPSTATESIZE error no_cpu_type_configured

  - There's no single platform type enabled, hence we get no definition of
    NR_IRQS:

	#error unknown nr of irqs

Well yes, these are all `features' of allnoconfig :-)
Or should we make sure you cannot build invalid configs like this?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
