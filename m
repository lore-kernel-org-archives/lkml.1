Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbXGSIxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbXGSIxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXGSIwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:52:53 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:37201 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734AbXGSIwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:52:53 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Date: Thu, 19 Jul 2007 10:52:48 +0200
User-Agent: KMail/1.9.4
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <20070719031712.bda40333.dilinger@queued.net> <200707191022.44572.ak@suse.de>
In-Reply-To: <200707191022.44572.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191052.50047.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 10:22, Andi Kleen wrote:
> > Wow, that's a really cool bug; nice work!  Don't forget to update
> > arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.  It
> > needs to include processor-cyrix.h.
>
> It also needs some big fat comments

No problem. Where to add?

Juergen
