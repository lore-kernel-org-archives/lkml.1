Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540Ab0ABN3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0ABN3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 08:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160Ab0ABN3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 08:29:35 -0500
Received: from rekin23.go2.pl ([193.17.41.16]:53654 "EHLO rekin23.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0ABN3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 08:29:35 -0500
Subject: =?UTF-8?Q?Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
Date: Sat, 02 Jan 2010 14:29:31 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2 stycznia 2010 13:36 	Daniel Borkmann <llug.dan@googlemail.com> napisał(a):

> Hi Bartłomiej,
> 
> Bartłomiej Zimoń wrote:
> > Use inotify from userspace could be interesting for such data,
> > but looks like sysfs/procfs doesn't send signal about data changed in file or maybe i'm wrong?
> > 
> > If sysfs/procfs is wrong for that so must create device file, but here secound problem 
> > how to notify that file/buffer has new data?
> 
> Actually, the file content of a procfs file is volatile and generated on
> the fly, just have a look at some device drivers or at the API.
> 

As I fought. Reading now sources of some char drivers.

> Did you have a look at the netlink protocol for communication from
> kernel to userspace?
> 

Ok i will :)

I will explain more what i'm going to do.
The idea is simple. Kernel before suspend/resume sends notification to 
registered kernel objects. So i have written small module to register
there and want now pass these data to /dev/file. It is 1byte so not a big deal.

I'm searching now for notification about new byte in buffer, as it is almost 
clear for async: http://www.xml.com/ldd/chapter/book/ch05.html#t4
but for sync still haven't find.

It could be interesting for NetworkManager to hook on such event.

Looks like my post arrives 2nd time in lkml.

Thx for reply.

Best Regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team

