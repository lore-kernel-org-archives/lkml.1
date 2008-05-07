Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYEGOJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYEGOJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYEGOJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:09:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52512 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753581AbYEGOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:09:22 -0400
Date: Wed, 7 May 2008 14:59:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507145949.4db3b26e@core>
In-Reply-To: <87lk2mbcqp.fsf@basil.nowhere.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<1210126286.3453.37.camel@ymzhang>
	<1210131712.3453.43.camel@ymzhang>
	<87lk2mbcqp.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 13:00:14 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
> > 3) Caller of lcok_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.
> 
> I have an older patchkit that introduced unlocked_fnctl for some cases. It was 
> briefly in mm but then dropped. Sounds like it is worth resurrecting?
> 
> tty_* is being taken care of by Alan.

The tty open/close paths are probably a few months away from dropping the
BKL.

Alan
