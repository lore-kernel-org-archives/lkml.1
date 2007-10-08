Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXJHUgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXJHUgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXJHUgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:36:38 -0400
Received: from barikada.upol.cz ([158.194.242.200]:51136 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbXJHUgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:36:37 -0400
Date: Mon, 8 Oct 2007 22:50:48 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071008205048.GY22435@flower.upol.cz>
References: <20071008200255.GA16497@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008200255.GA16497@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 10:02:55PM +0200, Sam Ravnborg wrote:
> One of the complaints that I continue to hear is that kbuild
> is lacking a way to 'remember' the ARCH and CROSS_COMPILE
> values originally used.

Yea, finally.

What about, that this is the first ever prompt, that must be shown and
written to the .config?

The zeroth one is an config entry of kernel version(s), .config can
configure and thus build successfully.


This are among other ideas about kconfig/kbuild, you know nothing
about yet.

So, what do you think?

Also, i'd like to propose sequencing of config-enable-build-this-unit
in config file(s), thus Makefile(s) (sometimes very small and stupid)
will be not necessary. Additional link ordering can be supplied as
meta-config information there. Shell scripting, very ugly in the view
of make syntax, will be natural in config files. Extending build
process to get hidden dependencies or right linking/other magic is
part of particular configuration. Hm?

And i want to repeat this to the wall:

make is stupid `test -nt` (non POSIX, but accepted my shells and GNU test
feature). Making any kind of hashing to make dream of kbuild-2.5
developers/fans -- more complete `up-to-date' heuristic possible, is just
like `md5sum > $OBJDIR/heuristic.com`, which is config selectable (for
those, who don't like a bit of slowdown).
--
-o--=O`C
 #oo'L O
<___=E M
