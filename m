Return-Path: <linux-kernel-owner+w=401wt.eu-S1764846AbXESW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764846AbXESW1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbXESW1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:27:31 -0400
Received: from quechua.inka.de ([193.197.184.2]:42011 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760152AbXESW1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:27:30 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: VFS design question
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <1179611516.6558.357.camel@toontown>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HpXOa-0003CR-00@calista.eckenfels.net>
Date: Sun, 20 May 2007 00:27:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <1179611516.6558.357.camel@toontown> you wrote:
> I tried to make it clear that I am clearly lacking expertise in this
> topic. I am currently working on a somewhat related topic and was hoping
> to get some reactions that would point me in the right directions as it
> is somewhat hard to judge the VFS design when you do not have prior
> experience in writing a file system on your own. Nowhere did I ask for a
> 10 paged review on the matter.

VFS abstraction is not too limiting, because the interface to user space is
fixed by posix or other standards in the libc. So als long as the new
filesystem want to support that semantic, it is not really limited.

There are some cases which are a bit hard, for example inode numbers -
especially when you want to provice NFS support, but that is not
specifically a VFS Problem.

And: VFS has evolved over time, that is the advantage of open source, you
can just include new functions in the old filesystems when you think you
need to impriove the framework.

That said, if you look at Reiser4 for example, there are some plug-in
extensions which are not yet possible in VFS, since it is a more high level
interface...

There are some different file close/lock semantics out there, and VFS does
not even try to abstract them.

gruss
Bernd
