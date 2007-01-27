Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXA0L3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXA0L3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 06:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXA0L3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 06:29:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49357 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXA0L3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 06:29:20 -0500
Date: Sat, 27 Jan 2007 03:29:12 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Cc: davem@davemloft.net, "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: + dynamic-kernel-command-line-sparc64-fix.patch added to -mm
 tree
Message-Id: <20070127032912.d155e66c.akpm@osdl.org>
In-Reply-To: <9e0cf0bf0701270314t3369dc7fke7fe8589be1d5bd7@mail.gmail.com>
References: <200701271103.l0RB32ES007734@shell0.pdx.osdl.net>
	<9e0cf0bf0701270314t3369dc7fke7fe8589be1d5bd7@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 13:14:57 +0200
"Alon Bar-Lev" <alon.barlev@gmail.com> wrote:

> I don't know why saved_command_line cannot be resolved and
> boot_command_line can be.
> They are both located in linux/init.h
> 
> extern char __initdata boot_command_line[];
> extern char *saved_command_line;
> 
> And the drivers/sbus/char/openprom.c do include it and I assume
> __ASSEMBLY__ is not defined.

hm.  It went away.  Maybe I dreamed it.

y'know, I've been plugging away at this crappile for over twelve hours,
have applied 55 distinct compile fixes so far and it's still not there.
Tomorrow I get to try to make it all run.  That should be amusing.
