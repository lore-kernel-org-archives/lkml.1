Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYIHQ7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYIHQ7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYIHQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:59:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYIHQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:59:39 -0400
Date: Mon, 8 Sep 2008 09:59:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       linux@sandersweb.net, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <alpine.DEB.1.10.0809080925400.10413@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0809080954370.3117@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
 <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
 <alpine.DEB.1.10.0809080925400.10413@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, david@lang.hm wrote:
> 
> I always understood the CPU selection to be "this CPU and ones compatible with
> it will work, others won't" unless generic was enabled.

No.

Read the help text.. 

Yes, we care about features that MATTER. But if compiles start using 
features that don't really matter, and make a specific kernel _too_ 
specific, then we need to reign in the madness.

IOW, it's a balance. On one hand, yes, the uarch makes sense. On the 
other, it's just stupid to have to worry about details that don't 
realistically make any difference at all - except whether the machine 
works or not.

And yes, we could just put this up as a Virtual PC bug. It clearly is. But 
in the end, it _still_ all boils down to a balance between "do we actually 
win anything by using NOPL statically" vs "do we lose anything by being 
too damn inconvenient".

		Linus
