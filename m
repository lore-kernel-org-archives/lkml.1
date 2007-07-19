Return-Path: <linux-kernel-owner+w=401wt.eu-S936701AbXGSIXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936701AbXGSIXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759317AbXGSIWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:22:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:55425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbXGSIWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:22:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Date: Thu, 19 Jul 2007 10:22:44 +0200
User-Agent: KMail/1.9.6
Cc: Juergen Beisert <juergen127@kreuzholzen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <200707190849.05983.juergen127@kreuzholzen.de> <20070719031712.bda40333.dilinger@queued.net>
In-Reply-To: <20070719031712.bda40333.dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191022.44572.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Wow, that's a really cool bug; nice work!  Don't forget to update
> arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.  It needs
> to include processor-cyrix.h.

It also needs some big fat comments

-Andi
