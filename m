Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbYD2QpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbYD2QpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYD2QpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:45:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44378 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbYD2QpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:45:03 -0400
Date: Tue, 29 Apr 2008 18:45:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Timur Tabi <timur@freescale.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080429164535.GB18018@uranus.ravnborg.org>
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481739BF.8010305@freescale.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:07:43AM -0500, Timur Tabi wrote:
> Tony Breeds wrote:
> 
> > On most linux systems echo supports c-syle escapes with "-e".  I'm
> > guessing which ever echo you're getting dosesn't do that.
> 
> Yes, that is my problem.
> 
> > I think the best fix is to ensure you're getting bash as your shell.
> 
> The script starts off with this line:
> 
> #!/bin/sh
> 
> Doesn't that mean that it should be interpreted by sh and not bash?
> 
> > A nasty hack would be to make check-lxdialog.sh do something like:
> > (echo ' #include CURSES_LOC';echo 'main() {}') | gcc '-DCURSES_LOC=<ncurses.h>' -DLOCALE -DKBUILD_NO_NLS -lncurses -xc - -o .lxdialog.tmp
> 
> This works.  Do you think if I posted a patch that makes this change, it will be
> accepted?

Yes.

	Sam
