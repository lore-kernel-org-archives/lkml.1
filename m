Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZEVV4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZEVV4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbZEVVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:55:58 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:61112 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbZEVVz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905221522560.3006-100000@iolanthe.rowland.org>
References: <ac3eb2510905221124y412dc3bdp65ad1b74373175a9@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905221522560.3006-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 22 May 2009 23:54:16 +0200
Message-ID: <ac3eb2510905221454u2fd7fe88tb3d6c13c6ae550a@mail.gmail.com>
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

On Fri, May 22, 2009 at 21:31, Alan Stern <stern@rowland.harvard.edu> wrote:
> Come to think of it, putting the lock files in sysfs isn't such a good
> idea.  The core will need to know whether the files are open, so we'll
> have to have our own file_operations structure for them.
>
> Which means the best place to put the lock files is probably somewhere
> in /dev.  Can this be made to work by generating appropriate uevents,
> with the default udev rules?

Nodes in /dev would  need a corresponding device in /sys and belong to
a subsystem to send an event. That sounds like a lot of stuff for a
simple interface like this. Can't we just add ioctls to the hub device
nodes to implement the locking?

Thanks,
Kay
