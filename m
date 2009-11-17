Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZKQBqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZKQBqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZKQBqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:46:23 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:52485 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZKQBqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:46:22 -0500
MIME-Version: 1.0
In-Reply-To: <1258388747.4912.52.camel@ierdnac>
References: <1258388747.4912.52.camel@ierdnac>
Date: Mon, 16 Nov 2009 20:46:27 -0500
Message-ID: <7e0fb38c0911161746o2c93d056r6fa052f8b2def913@mail.gmail.com>
Subject: Re: [warning] kernel-2.6.31.5
From: Eric Paris <eparis@parisplace.org>
To: andrei.popa@i-neo.ro
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 11:25 AM, Andrei Popa <andrei.popa@i-neo.ro> wrote:
> ------------[ cut
> here ]------------
> WARNING: at fs/notify/inotify/inotify_user.c:398 inotify_remove_from_idr
> +0x80/0xa0()

Mostly fixed in 2.6.32-rc6 and should also be mostly fixed in the next
2.6.31 stable release.  A tiny window must still exist since we saw
this once with a -rc6 kernel at kerneloops.  I pulled back out my old
stress test and was able to hit it on a large multiway system today in
Linus' latest kernel.  For most practical purposes and users this is
fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9f0d793b52eb2266359661369ef6303838904855

But apparently it's not totally fixed, I'm looking into it again...

-Eric
