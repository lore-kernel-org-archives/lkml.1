Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbXJIIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbXJIIXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbXJIIXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 04:23:33 -0400
Received: from barikada.upol.cz ([158.194.242.200]:60928 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbXJIIXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 04:23:33 -0400
Date: Tue, 9 Oct 2007 10:37:43 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009083743.GA22435@flower.upol.cz>
References: <20071008200255.GA16497@uranus.ravnborg.org> <20071008205048.GY22435@flower.upol.cz> <20071009041743.GA21552@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009041743.GA21552@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 06:17:43AM +0200, Sam Ravnborg wrote:
> > 
> > What about, that this is the first ever prompt, that must be shown and
> > written to the .config?
> Two issues to fix before we can do this:
> 1) chocie values cannot have more than one prompt

what occupying all my time now is to try to make fast and easy (text/tty)
user interface, based solely on TERM=linux capability. It is such, but
deep in ncurses/lxdialog wrappers. Having more flexible TUI without
all past stereotypes is the major point in making any progress for
flexible configuration interface. Remember, how blind `select` hurts.
It does due to UI limitations in first place, IMHO.

> 2) We need to share much more Kconfig* between the individual architectures
>    First step is to let all arch's use drivers/Kconfig

All syntax wars are over, now order is the second thing to achieve. Like
in x86 merge case, this is purely technical thing with a bit of manual
work after that. sed magic for (nearly any kind :) of textual processing
i can guarantee without (yet another) C (like fixdep.c, parts of
sumversion.c, etc.)

> Let's get the two items above solved then we can revisit adding arch selection
> to kconfig (where it belongs in the end).
> And neither require a rewrite of kconfig...

Since i try to do test driven development, it's more easy for me to
understand/fix/test today's things via making bits from scratch. Fresh
view can do more on debugging of the logic level also.
____
