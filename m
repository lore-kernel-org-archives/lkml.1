Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbXCQIey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbXCQIey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXCQIey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:34:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51401 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbXCQIex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:34:53 -0400
Date: Sat, 17 Mar 2007 09:35:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Don Mullis <dwm@meer.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       kbuild-devel <kbuild-devel@lists.sourceforge.net>,
       kai <kai@germaschewski.name>
Subject: Re: [PATCH] kbuild: move tags from ARCH and include/ ahead of drivers
Message-ID: <20070317083528.GE27451@uranus.ravnborg.org>
References: <1167934492.2668.97.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1167934492.2668.97.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 04, 2007 at 10:14:52AM -0800, Don Mullis wrote:
> Move tags extracted from the ARCH and include/ sub-trees ahead of
> those from device drivers, so that the former will appear first
> during searches. 
> 
> Saves user time during interactive searches for certain patterns
> that happen to find unwanted matches in driver files.
> 
> Example in emacs:
> 	 "M-x find-tag PAGE_SIZE"
> 	 "M-1 M-." (repeated until definition from asm-i386/page.h appears)
> 
> Signed-off-by: Don Mullis <dwm@meer.net>

Applied, thanks.

	Sam
