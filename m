Return-Path: <linux-kernel-owner+w=401wt.eu-S937384AbXGSJ0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937384AbXGSJ0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXGSJZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:25:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:59235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbXGSJZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:25:53 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Juergen Beisert <juergen127@kreuzholzen.de>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Date: Thu, 19 Jul 2007 11:25:46 +0200
User-Agent: KMail/1.9.6
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <200707191022.44572.ak@suse.de> <200707191052.50047.juergen127@kreuzholzen.de>
In-Reply-To: <200707191052.50047.juergen127@kreuzholzen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191125.47079.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 10:52:48 Juergen Beisert wrote:
> On Thursday 19 July 2007 10:22, Andi Kleen wrote:
> > > Wow, that's a really cool bug; nice work!  Don't forget to update
> > > arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.  It
> > > needs to include processor-cyrix.h.
> >
> > It also needs some big fat comments
> 
> No problem. Where to add?

Where the inlines are defined.

Also can you please resubmit full patches with full description
and Signed off lines, not incrementals? Thanks.

-Andi
