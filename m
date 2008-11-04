Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYKDXYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYKDXYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYKDXXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:23:48 -0500
Received: from vena.lwn.net ([206.168.112.25]:38444 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYKDXXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:23:47 -0500
Date: Tue, 4 Nov 2008 16:23:45 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       mtk.manpages@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC] Documentation tree sub-directories reorg.
Message-ID: <20081104162345.38729b20@bike.lwn.net>
In-Reply-To: <4910D1BC.9060100@xenotime.net>
References: <4910D1BC.9060100@xenotime.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 14:50:36 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> I would like to use a few more sub-directories in the Documentation/
> tree to try to help clean it up some.  E.g., move some drivers/block/
> doc files to Documentation/blockdev/ and move some serial/tty/chardev
> doc files to Documentation/serial/

This all makes fine sense to me, but I do wonder if we shouldn't also
create an "obsolete" subdirectory and put some of those files there?
For example, paride.txt starts off this way:

	Owing to the simplicity and near universality of the parallel port
	interface to personal computers, many external devices such as
	portable hard-disk, CD-ROM, LS-120 and tape drives use the parallel
	port to connect to their host computer.

Said ports are not quite as universal as they once were.  The document also
points to a nonexistent web page and a dead mailing list.  It's hard to
imagine that it's actually doing anybody any good at all.  Even if somebody
out there is still using the paride drivers (can there possibly be?), they
aren't likely to be getting much help here.

jon
