Return-Path: <linux-kernel-owner+w=401wt.eu-S1763904AbYBLTIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763904AbYBLTIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbYBLTIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:08:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39327 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761143AbYBLTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:08:41 -0500
Date: Tue, 12 Feb 2008 11:08:18 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080212110818.62496cf4@laptopd505.fenrus.org>
In-Reply-To: <20080212185012.GA2348@uranus.ravnborg.org>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>
	<20080212185012.GA2348@uranus.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 19:50:12 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > Now I realize that certain distros have patched gcc to compensate
> > for their lack of distro wide CFLAGS, and it's great to work around
> > that... but would there be a way to NOT disable this for
> > CONFIG_CC_STACKPROTECTOR please? It would have made this exploit
> > not possible for those kernels that enable this feature (and that
> > includes distros like Fedora)
> 
> I guess the problem is that we in arch/x86/Makefile enable the
> stackprotector but then later in the main Makefile disables it.
> So the right way to approach this should be to always disable it and
> the reenable it in the arch Makefile.
> So something like this?


the patch works fine for me.
Linus, can we please get this merged into .25? it will at least
again limit the damage exploits like the vmsplice one can do..

(I think it's also worth it for -stable)
