Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZC3WAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZC3WAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZC3WAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:00:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbZC3WAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:00:39 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.29
Date: Tue, 31 Mar 2009 00:00:10 +0200
User-Agent: KMail/1.9.10
Cc: Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <1238168777.5969.18.camel@marge.simson.net> <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903310000.11522.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+lu3zqW6BBk+HGKkYx6+SjM7WN67SIVmP6b1f
 JnfE+uUC7niXcYx/GvLoKUWsUbwyGTjOxaHHGRQjtiJ/A0je5M
 0GaYlsuzpCTLRdW2HbdLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 27. März 2009 schrieb Linus Torvalds:

> In other words, the main Makefile version is totally useless in
> non-linear development, and is meaningful _only_ at specific release
> times. In between releases, it's essentially a random thing, since
> non-linear development means that versioning simply fundamentally isn't
> some simple monotonic numbering. And this is exactly when
> CONFIG_LOCALVERSION_AUTO is a huge deal.

Well, you guys always see things from a deeply involved kernel developer 
_using git_ POV - which I do understand and accept (unlike hats nobody can 
change his head after all ;-), but there are other approaches to kernel 
source code, e.g. git is also really great for tracking the kernel 
development without any further involvement apart from using the resulting 
trees.

I build kernel rpms from your git tree, and have a bunch of BUILDs lying 
around. Sure, I can always fetch the tarballs or fiddle with git, but why? 
Having a Makefile start commit allows to make sure with simplest tools, 
say "head Makefile" that a locally copied 2.6.29 tree is really a 2.6.29, 
and not something moving towards the next release. That's all, nothing 
less, nothing more, it's just a strong hint which blend is in the box.

I always wonder, why Arjan does not intervene for his kerneloops.org 
project, since your approach opens a window of uncertainty during the merge 
window when simply using git as an efficient fetch tool.

Ducks and hides now,
Pete
