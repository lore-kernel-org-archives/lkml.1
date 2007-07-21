Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbXGUJaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbXGUJaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbXGUJaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:30:21 -0400
Received: from barikada.upol.cz ([158.194.242.200]:49488 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbXGUJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:30:20 -0400
Date: Sat, 21 Jul 2007 11:43:54 +0200
To: Andreas Schwab <schwab@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, kbuild-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 25/33] kbuild: use POSIX BRE in headers install target
Message-ID: <20070721094353.GJ475@flower.upol.cz>
References: <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <E1ICAEU-0005an-5F@flower> <jewswu9ncf.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jewswu9ncf.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 10:23:44AM +0200, Andreas Schwab wrote:
> Oleg Verych <olecom@flower.upol.cz> writes:
> 
> >> +		-e 
> >> "s/[[:space:]]__user[[:space:]]\{1,\}
> >
> > substitute one or more ' __user '
> 
> Substitute ' __user' followed by one or more ' '.  \{\} applies only to
> the last RE atom.

Right, that's why i've used '  *' sometimes.

Thanks.

> Andreas.
> 
____
