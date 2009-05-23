Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbZEWWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbZEWWsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZEWWsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:48:11 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:59909 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZEWWsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:48:11 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905221801470.22960-100000@iolanthe.rowland.org>
References: <ac3eb2510905221454u2fd7fe88tb3d6c13c6ae550a@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905221801470.22960-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 24 May 2009 00:47:51 +0200
Message-ID: <ac3eb2510905231547y6da1b3a6m6ef8921c8f56dc00@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 00:07, Alan Stern <stern@rowland.harvard.edu> wrote:

>> Can't we just add ioctls to the hub device
>> nodes to implement the locking?
>
> Yes, that would work.  Closing the hub device file would release all
> the locked ports.
>
> It wouldn't leave any lock files for user programs.  They would have to
> arrange the locking among themselves somehow.  Would that be okay?

I would expect that userspace drivers competing about raw USB devices
wouldn't be that common. And I guess, most of these problems can
probably be solved by simple file permissions/ACLs applied to the USB
device nodes, in the same way the access to the hub device node would
be granted to lock-out the kernel drivers.

Kay
