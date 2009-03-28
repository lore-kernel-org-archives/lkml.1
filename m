Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZC1AEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZC1AEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZC1AEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:04:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbZC1AEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:04:32 -0400
Date: Fri, 27 Mar 2009 17:02:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Anholt <eric@anholt.net>
cc: lkml <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.sf.net>
Subject: Re: your mail
In-Reply-To: <1238196389.625.430.camel@gaiman.anholt.net>
Message-ID: <alpine.LFD.2.00.0903271657360.3994@localhost.localdomain>
References: <1238196389.625.430.camel@gaiman.anholt.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Eric Anholt wrote:
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-next

Grr.

Guys, what the *hell* is wrong with you, when you can't even react to 
trivial warnings and fix buggy code pointed out by the compiler?

If you had _ever_ compiled this on x86-64, you would have seen:

  drivers/gpu/drm/i915/i915_gem_debugfs.c: In function ‘i915_gem_fence_regs_info’:
  drivers/gpu/drm/i915/i915_gem_debugfs.c:201: warning: format ‘%08x’ expects type ‘unsigned int’, but argument 7 has type ‘size_t’

and this is not the first time this has happened.

See commits f06da264cfb0f9444d41ca247213e419f90aa72a and 
aeb565dfc3ac4c8b47c5049085b4c7bfb2c7d5d7.

What's so hard with keeping the build warning-clean, and fixing these 
things _long_ before they hit my tree?

Some basic quality control. PLEASE.

		Linus
