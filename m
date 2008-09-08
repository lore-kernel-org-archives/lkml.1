Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYIHPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYIHPmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYIHPmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:42:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44645 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYIHPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:42:05 -0400
Date: Mon, 8 Sep 2008 17:45:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080908154535.GL26079@one.firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 08:09:48AM -0700, Linus Torvalds wrote:
> On Sun, 7 Sep 2008, H. Peter Anvin wrote:
> > 
> > Under that logic we shouldn't even have CPU configurables, since you want it
> > to "just work" whatever crap you're running on.  That is EXACTLY what
> > CONFIG_X86_GENERIC means
> 
> I dunno.. Event he help-text doesn't actually agree with that:

The help text matches in how I wrote this option originally.
The original use case was the 128 byte P4 cache lines.

-Andi
