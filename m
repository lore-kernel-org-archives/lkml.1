Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbYBPUUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbYBPUUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYBPUUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:20:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35713 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750756AbYBPUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:20:29 -0500
Date: Sat, 16 Feb 2008 20:12:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2 regression: LVM cannot find volume group
Message-ID: <20080216201206.1452cfe7@core>
In-Reply-To: <47B73616.9050303@imap.cc>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	<47B73616.9050303@imap.cc>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 20:14:30 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> 2.6.25-rc2 fails to bring up my openSUSE 10.3 PC because LVM
> cannot find the volume group containing the root file system.
> 2.6.25-rc1 has the same problem, 2.6.24 works fine.

Compile in SCSI disk support. Modular even if loaded in initrd it seems
to have broken somewhere.
