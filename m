Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbXIPTRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbXIPTRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXIPTRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:17:33 -0400
Received: from barikada.upol.cz ([158.194.242.200]:33343 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIPTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:17:32 -0400
Date: Sun, 16 Sep 2007 21:32:58 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kbuild-devel@lists.sourceforge.net
Subject: Rename asm-offsets tool or not? (Re: [patch 01/03] kbuild, asm-values: infrastructure)
Message-ID: <20070916193258.GD13543@flower.upol.cz>
References: <20070612233650.486224000@flower.upol.cz> <20070612234558.648949000@flower.upol.cz> <20070916182912.GA9630@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916182912.GA9630@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 08:29:12PM +0200, Sam Ravnborg wrote:
> Hi Oleg.

Hallo. Nice, you are bringing it back. I'll try to have LKML-like
output this time, not a makefile mess and stuff:

[]
> I see no value in renaming from asm_offset to asm_value - please drop it.
> Introducing the generic asm-values.h should wait and when you do
> you should be preapred to update all architectures (ecasue otherwise it
> will not happen).

All archs, are using same syntax. But.

Interesting exception is MIPS, where tokens are organized and implemented
more nicely, that is where *asm-values* name coming from, actually. One
can see all that text, size, constant tokens in addition to just offsets.

So, if name change isn't worth, then OK; filename compatibility check, as
one in `linux/Kbuild', is easy to hack as well to remove.

But nice feature/tool with meaningful name and functionality is just
another thing.

Opinions?
____
