Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZKJOCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZKJOCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbZKJOCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:02:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64573 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZKJOCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:02:45 -0500
MIME-Version: 1.0
In-Reply-To: <20091110133447.GE26144@atrey.karlin.mff.cuni.cz>
References: <a4875c0e0911091128g3920726bk2e20be67920dc483@mail.gmail.com>
	 <a4875c0e0911100417j1a9fba09tce5da4a5511111c0@mail.gmail.com>
	 <a4875c0e0911100424h947058bg5c7efc6e2d7d817c@mail.gmail.com>
	 <a4875c0e0911100426t2e95cf21g8bbad12438804ef6@mail.gmail.com>
	 <20091110133447.GE26144@atrey.karlin.mff.cuni.cz>
Date: Tue, 10 Nov 2009 15:02:49 +0100
Message-ID: <a4875c0e0911100602vc74b288ga2323312bccb21b@mail.gmail.com>
Subject: Re: Fwd: eifs/fmfs (everything is filesystem/file mapping filesystem)
From: mobi phil <mobi@mobiphil.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> google fuse
Sometimes manipulation works :) .. I did intentionally not mention
fuse, so that we can focus on the topic when somebody will ask :) I
know fuse, it is a treasure, am using fuse for db, wikipedia etc.,
etc. However the only annoying thing with fuse and kernel space
drivers is that you have to mount before access. (And mount is not
enough, like with loop device, you cannot mount straightforward
partitions on a loop device) you have to tell the computer extra
annoying instruction, that should be obvious, once setting up the
framework. That is fuse is a partial solution for a powerful concept
that I named "filesystem anywhere". I do not want to bother mounting
fuse when I want to access a file that has a hierarchical structure,
and the guy knowing to do the mapping from that internal structure to
hierarchical filesystem is in place. Similar ideas were already
discussed here I am sure (I was not on the kernel mailing lists that
time), as some people (I would like to avoid names) were insisting on
seeing data on a computer throug sthg. called unified path system if I
am not mistaking.

by the way another example:

#>ls /mydata/ftpadresses/boot.kernel.org@http/gpxe_images
#>ls /mygitprojects/linux-2.6/.git@git/tags
#>ls /mygitprojects/linux-2.6/.git@git/branches
or with defaults
#>ls /mygitprojects/linux-2.6/.git@/tags
#>ls /mygitprojects/linux-2.6/.git@/branches


etc





-- 
rgrds,
mobi phil

being mobile, but including technology
http://mobiphil.com
