Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXLUAxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXLUAxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760018AbXLUAwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:52:45 -0500
Received: from gw.goop.org ([64.81.55.164]:41349 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759625AbXLUAwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:52:44 -0500
Message-ID: <476B0E59.5070503@goop.org>
Date: Thu, 20 Dec 2007 16:52:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
References: <20071219223534.129042140@goop.org> <20071220094940.GA14227@elte.hu> <20071220112022.GA15832@elte.hu> <476AD9EA.7010108@goop.org> <20071220213906.GB11897@elte.hu> <476AE7D6.9000600@goop.org> <20071220222429.GA28029@elte.hu>
In-Reply-To: <20071220222429.GA28029@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> it's also a lot less frustrating and a lot more enjoyable that way IMO. 
> If it's 50 small patches, then so be it ... 50 patches only take ~2 
> seconds more for me to apply to x86.git (which time is immediately saved 
> by the vastly improved reviewability and testability of a 50 patches 
> set), so dont worry about any overhead on the maintainers side. And 
> you'll end up moving up on the v2.6.25 contributors top-list on LWN as 
> well ;-) The worst aspect of it is writing up the 50 changelogs (i use 
> pre-created templates for that) and figuring out how to script a 
> patch-bomb to lkml. In every other aspect it's a win-win scenario for 
> everyone involved.

Well, testing for bisectability requires compiling each patch as its
applied, which gets painful for something like this where any change
will rebuild the world.  And dealing with patch conflicts caused by
changing early patches in the series is never fun.

But I'm refactoring the series into smaller pieces now.  Knowing what
the outcome should look like, and there the pitfalls are, makes it
fairly easy.

    J
