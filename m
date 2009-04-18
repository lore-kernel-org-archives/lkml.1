Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZDRKQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZDRKQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 06:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZDRKQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 06:16:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49622 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZDRKQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 06:16:07 -0400
Date: Sat, 18 Apr 2009 11:14:44 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, takata@linux-m32r.org,
       Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] m32r: move include/asm-m32r to arch/m32r/include/asm
Message-ID: <20090418101444.GA9768@flint.arm.linux.org.uk>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com> <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain> <20090417221440.GA16791@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417221440.GA16791@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 12:14:40AM +0200, Sam Ravnborg wrote:
> It was not stale as arm create a few files in asm-arm so it
> just ignored a few generated files.
> 
> I have discussed wth Al to introduce a new directory:
> 
>     include/gen/
> 
> that will hold all such generated files including asm-offsets.h.
> When I have this ready the asm -> asm-$(ARCH) symlink will die.
> 
> Do not bring back the asm-arm/.gitignore,
> we will live with that until include/gen are in place.

We're going to get include/asm-arm/mach-types.h committed via someone
elses tree sooner or later then, unless include/gen or whatever comes
in ASAP.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
