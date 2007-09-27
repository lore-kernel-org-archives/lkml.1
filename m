Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXI0L3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXI0L3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXI0L2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:28:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37961 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbXI0L2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:28:53 -0400
Date: Thu, 27 Sep 2007 13:30:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Updating include/asm symlink when $ARCH changes
Message-ID: <20070927113019.GA30567@uranus.ravnborg.org>
References: <20070927092521.GA27491@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927092521.GA27491@deprecation.cyrius.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:25:21AM +0200, Martin Michlmayr wrote:
> I cross compile arm and mips kernels from the same kernel tree.  When
> I build a kernel the first time with a fresh kernel tree, the
> include/asm symlink is set properly.  However, when I compile for a
> different $ARCH, the include/asm is not changed and the build fails.
> 
> Would it be possible for the build system to update the include/asm
> symlink when it doesn't correspond to the architecture you're
> currently trying to build for?

You are not the first to ask for this - suprise.
Alexey point out a good solution but I have added to my tod list
to do something a bit more intelligent when ARCH changes.

The patches I have seen so far has been lacking fundamental functionality
and on top of this I hope to find a nice way to preserve CROSSCOMPILE
since that often change too.

	Sam
