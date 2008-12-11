Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYLKVVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYLKVVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYLKVVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:21:03 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:52692 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbYLKVVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:21:02 -0500
Date: Thu, 11 Dec 2008 22:22:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] make INIT_FS use the __RW_LOCK_UNLOCKED initialization
Message-ID: <20081211212228.GB27223@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0812101832200.21545@gandalf.stny.rr.com> <20081210234307.GI28946@ZenIV.linux.org.uk> <8bd0f97a0812101707p7df7745dk9840b05c0b26184b@mail.gmail.com> <alpine.DEB.1.10.0812102010100.29200@gandalf.stny.rr.com> <20081211023439.GJ28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211023439.GJ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Guys, let's not take it to init/main.c, please.  That file is basically
> a trashcan and I'd rather take that stuff to more or less relevant places
> in kernel/* and fs/*.  FWIW, I've done that with init_files (fs/file.c)
> some time ago.  For init_fs...  Hell knows.  Might make sense to take
> that to separate file, actually (kernel/exit.c and kernel/fork.c bits
> related to fs_struct).
> 
> BTW, why does sparc64 export put_fs_struct?
I have sent a patch to davem now to get it removed.

	Sam
