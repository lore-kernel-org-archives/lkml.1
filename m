Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZCLU4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZCLU4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZCLU4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:56:30 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47891 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZCLU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:56:29 -0400
Date: Thu, 12 Mar 2009 21:58:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090312205826.GA14205@uranus.ravnborg.org>
References: <200903120437.03837.rob@landley.net> <20090312095854.GA9398@uranus.ravnborg.org> <200903121503.37195.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903121503.37195.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And if you look up the content of "include/asm-generic/Kbuild.asm"
> 
> Ah, I was grepping for header-y and this is full of unifdef-y, so I didn't 
> look too closely at this file.  (I did glance at it, but the first thing I saw 
> was "errno.h" and there's an errno.h in the include/asm-generic directory, so 
> I thought it was describing itself.  I presume it tries the arch one first and 
> falls back to asm-generic if it's not there?)
No - it uses what it is told to use. Look again.
We have in asm-generic two files:
Kbuild <= what is exported always and located in asm-generic
Kbuild.asm <= exported from archs asm - just a common list of file names
> 
> 
> Seems kind of silly to let git grind away downloading hundreds of megabytes of 
> history that'll just get wiped (especially since that tree gets regenerated 
> nightly), but oh well.  Assuming that kernel development is git-centric enough 
> that a tarball version of a regenerated nightly resource just never seemed 
> important, said git repository would be on git.kernel.org, but where...
> linux/kernel/git/eranian/linux-next.git isn't it...
> linux/kernel/git/mchehab/linux-next.git isn't it...
> Ah, linux/kernel/git/sfr/linux-next.git is the one I'm looking for.  Now where 
> was the magic incantation to translate from the web url to a git url...  Ah, 
> at the top of the page.

Usual people read the announcement mails from Stephen and follow the instructions there.
And many people keep an updated git tree around speeding up the process.

I cannot remember when I clone a full kernel tree - long time ago for sure.

	Sam
