Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZBQKCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZBQKCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZBQKBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:01:54 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41814 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZBQKBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:01:53 -0500
MIME-Version: 1.0
In-Reply-To: <499A7EE2.50108@imap.cc>
References: <499A7EE2.50108@imap.cc>
Date: Tue, 17 Feb 2009 11:01:51 +0100
Message-ID: <ac3eb2510902170201t696df348ka167c12ad5819494@mail.gmail.com>
Subject: Re: 2.6.28.[45] boot failure: request_module: runaway loop modprobe 
	binfmt-464c
From: Kay Sievers <kay.sievers@vrfy.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:09, Tilman Schmidt <tilman@imap.cc> wrote:
> My workhorse machine (Pentium D 940, Intel DG965QF board,
> mirrored SATA disks), which runs fine with kernel:
> ts@xenon:~> uname -a
> Linux xenon 2.6.28.3-testing #1 SMP PREEMPT Mon Feb 2 23:32:07 CET 2009 i686 i686 i386 GNU/Linux
> fails to come up with an identically configured 2.6.28.4 or 2.6.28.5
> kernel. The boot process hangs at about the time the root
> file system is mounted, the last messages being (scribbled
> down manually on a piece of paper, please make allowances):
>
> /dev/RAID/root: recovering journal ... clean
> fsck successful. Mounting root device r/w
> Mounting root /dev/RAID/root
> kjournald starting. Commit interval 5 seconds
> EXT3 FS on dm-0, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c

Are you sure, that you don't have a 32/64 bit mismatch between the
kernel and userspace? Like you miss 32-bit emulation in a 64-bit
kernel, or your modprobe is 64-bit and you are trying to run it on a
32-bit kernel?

Kay
