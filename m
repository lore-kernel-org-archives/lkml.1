Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbYFZNaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbYFZNaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760314AbYFZNaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:30:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42104 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbYFZNaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:30:02 -0400
Date: Thu, 26 Jun 2008 15:30:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080626133047.GA11762@uranus.ravnborg.org>
References: <20080610214544.GA14824@damson.getinternet.no> <20080618103006.GF15255@elte.hu> <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com> <20080626120202.GH29619@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626120202.GH29619@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:02:02PM +0200, Ingo Molnar wrote:
> 
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
> > Vegard (a.k.a. "The Churninator")

Hi Vegard.

Can I ask you to chase all uses of #include <asm-x86/xxx.h>
and convert them to #include <asm/xxx.h>

When we move include/asm-x86 to arch/x86/include/asm this is needed and
better to fix these sooner.

	Sam

