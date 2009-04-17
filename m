Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZDQWM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZDQWM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbZDQWMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:12:38 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53923 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbZDQWMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:12:37 -0400
Date: Sat, 18 Apr 2009 00:14:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: takata@linux-m32r.org, Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [GIT PULL] m32r: move include/asm-m32r to arch/m32r/include/asm
Message-ID: <20090417221440.GA16791@uranus.ravnborg.org>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com> <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:37:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 17 Apr 2009, takata@linux-m32r.org wrote:
> > 
> > I have moved asm-m32r headers and build-checked.
> > 
> > Please pull from the following m32r git tree:
> >   git://www.linux-m32r.org/git/takata/linux-2.6_dev.git for-linus
> 
> Ok, pulled.
> 
> I also removed the last remnants of asm-h8300 (a file that was added after 
> the more of everything else) and asm-arm (a stale .gitignore file).

It was not stale as arm create a few files in asm-arm so it
just ignored a few generated files.

I have discussed wth Al to introduce a new directory:

    include/gen/

that will hold all such generated files including asm-offsets.h.
When I have this ready the asm -> asm-$(ARCH) symlink will die.

Do not bring back the asm-arm/.gitignore,
we will live with that until include/gen are in place.

	Sam
