Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbXIJQha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbXIJQha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXIJQhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:37:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45666 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbXIJQhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:37:23 -0400
Date: Mon, 10 Sep 2007 18:38:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: pradeep singh rautela <rautelap@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Q]Adding src files to 2.6.18 kernel and build failure query
Message-ID: <20070910163847.GA30699@uranus.ravnborg.org>
References: <6bc632150709100905y7c5c2camaa0044cf6fa09ea2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bc632150709100905y7c5c2camaa0044cf6fa09ea2@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 09:35:52PM +0530, pradeep singh rautela wrote:
> Hi,
> 
> I am facing some problem understanding and using the kernel Kbuild
> system. I tried googling but not much of help.
> 
> Thanks to a good kbuild documentation in the tree. It looks like $(LD)
> -r is not able to do what it is supposed to do. May be i am doing
> something wrong?
> 
> here is a brief summary of what i am doing -
> 
> I added some .c files to a new dir under net/foo/ .
> Added corresponding .h files to a new dir under include/foo/
> 
> Create a Kconfig and Makefile in net/foo/ directory.
> Added corresponding entries to Makefile and Kconfig in the net/ dir.
> 
> I happily executed a make with a beaming face after selecting the foo
> option after doing a
> $make menuconfig.
> 
> To my surprise i got this error :-
> 
> make[1]: *** No rule to make target `arch/i386/kernel/vmlinux.lds',
> needed by `__build'.  Stop

Did the kernel build before you started adding your stuff?
It looks like you broke something non-obvious when adding your stuff since the
above failure should not happen just by adding a new directory under net/

	Sam
