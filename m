Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbXIAHKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbXIAHKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 03:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXIAHK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 03:10:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbXIAHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 03:10:27 -0400
Date: Sat, 1 Sep 2007 00:08:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Tony Luck <tony.luck@intel.com>, John Stultz <johnstul@us.ibm.com>,
       Paolo Ornati <ornati@fastwebnet.it>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Stephen Ziemba <sziemba@ecn.purdue.edu>
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches
In-Reply-To: <46D59081.2040605@googlemail.com>
Message-ID: <alpine.LFD.0.999.0709010006570.14418@woody.linux-foundation.org>
References: <46D59081.2040605@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Aug 2007, Michal Piotrowski wrote:
> 
> Clocks & time
> 
> Subject         : "double" hpet clocksource && hard freeze
> References      : http://lkml.org/lkml/2007/8/23/257
> Last known good : ?
> Submitter       : Paolo Ornati <ornati@fastwebnet.it>
> Caused-By       : Tony Luck <tony.luck@intel.com>
>                   commit 0aa366f351d044703e25c8425e508170e80d83b1
> Handled-By      : John Stultz <johnstul@us.ibm.com>
>                   Tony Luck <tony.luck@intel.com>
> Patch           : http://lkml.org/lkml/2007/8/23/285
> Status          : patch available

Should be solved by 3b2b64fd311c92f2137eb7cee7025794cd854057, although 
differently from the the patch suggested above. So the regression should 
be gone a of -rc5.

		Linus
