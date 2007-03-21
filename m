Return-Path: <linux-kernel-owner+w=401wt.eu-S965322AbXCUWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322AbXCUWSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965346AbXCUWSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:18:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36573 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXCUWSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:18:36 -0400
Date: Wed, 21 Mar 2007 23:19:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       sam@ravnborg.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070321221905.GA22623@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net> <20070320214714.0e584cd4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320214714.0e584cd4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 09:47:14PM -0800, Andrew Morton wrote:
> On Tue, 20 Mar 2007 12:20:16 -0700 Kees Cook <kees@outflux.net> wrote:
> 
> > I can't 
> > get 2.6.21-rc4-mm1 to compile (with or without this fix):
> > 
> >   GEN     .version
> > init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> > make: *** [.tmp_vmlinux1] Error 2
> 
> How'd you manage that?
> 
> Sam, I think this is a you-thing rather than a dwmw2-thing?
Took a look. Things looked pretty OK but an updated patch
applied to kbuild.git.
Corrected a few things in the Makefile and combined the
patch from dwmw2 and Stephane.

kbuild.git pused out and patches follows.

	Sam
