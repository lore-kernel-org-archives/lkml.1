Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYIHQ5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYIHQ5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYIHQ4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:56:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41922 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYIHQ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:56:55 -0400
Date: Mon, 8 Sep 2008 19:00:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       linux@sandersweb.net, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080908170029.GP26079@one.firstfloor.org>
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 09:20:06AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 8 Sep 2008, H. Peter Anvin wrote:
> > 
> > And yes, it should be the default.  The patch I have makes it
> > "default y" as well as change the help text.
> 
> It sounds like it shouldn't be a default at all, it should just _always_ 
> be on, if there really are gcc's that care that much. Most of our 

Originally it was an option because the 128 byte cache line it selects
caused bloat in several important data structures. That was back
then when cache line padded NR_CPUs arrays were still pretty common.
I don't know if it's still a problem, but before making it default y
it would be good to check the dynamic+static memory cost at least.

-Andi
