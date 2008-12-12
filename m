Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYLLE2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYLLE2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 23:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbYLLE2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 23:28:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34032
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756221AbYLLE2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 23:28:08 -0500
Date: Thu, 11 Dec 2008 20:28:07 -0800 (PST)
Message-Id: <20081211.202807.55399657.davem@davemloft.net>
To: sam@ravnborg.org
Cc: viro@ZenIV.linux.org.uk, rostedt@goodmis.org, vapier.adi@gmail.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] make INIT_FS use the __RW_LOCK_UNLOCKED initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081211212228.GB27223@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0812102010100.29200@gandalf.stny.rr.com>
	<20081211023439.GJ28946@ZenIV.linux.org.uk>
	<20081211212228.GB27223@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 11 Dec 2008 22:22:28 +0100

> > 
> > Guys, let's not take it to init/main.c, please.  That file is basically
> > a trashcan and I'd rather take that stuff to more or less relevant places
> > in kernel/* and fs/*.  FWIW, I've done that with init_files (fs/file.c)
> > some time ago.  For init_fs...  Hell knows.  Might make sense to take
> > that to separate file, actually (kernel/exit.c and kernel/fork.c bits
> > related to fs_struct).
> > 
> > BTW, why does sparc64 export put_fs_struct?
> I have sent a patch to davem now to get it removed.

It was used by the sunos and solaris syscall compat layers, which were
removed recently.
