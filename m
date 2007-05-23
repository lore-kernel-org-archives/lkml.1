Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbXEWX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbXEWX2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXEWX2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:28:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709AbXEWX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:28:08 -0400
Date: Wed, 23 May 2007 16:27:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@mail.ru>, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523162751.16980a45.akpm@linux-foundation.org>
In-Reply-To: <1179962229.8575.4.camel@localhost>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<1179962229.8575.4.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 17:17:09 -0600
Zan Lynx <zlynx@acm.org> wrote:

> On Wed, 2007-05-23 at 00:42 -0700, Andrew Morton wrote: 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> > 
> > - A new readahead patch series.  This needs serious review and performance
> >   testing please.
> > 
> > - Added Ingo's CFS CPU scheduler
> > 
> > - Xen dom-U support is now in the x86 tree.
> 
> I am having weird problems with USB keyboard and mouse.  The USB
> keyboard will drop keystrokes, but not all of them.  The mouse seems to
> move fine but drops clicks.  Could be that an occasional missed move
> event isn't noticeable.  Nothing is logged when a key is dropped.
> 
> However, I did have some of this when it was first booting:
> 
> BUG: at drivers/hid/hid-core.c:778 implement()
> 
> Call Trace:
> [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
> [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
> [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
> [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
> [<ffffffff8053523e>] do_page_fault+0x42e/0x880
> [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
> [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
> [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
> [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
> [<ffffffff8020a16e>] system_call+0x7e/0x83
> 
> Here's the entire dmesg:
>
> [ snippage ]
>

Thanks.  Let's add some cc's.

