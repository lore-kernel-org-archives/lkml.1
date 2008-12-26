Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYLZVJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYLZVJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYLZVJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:09:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45603 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYLZVJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:09:35 -0500
Date: Fri, 26 Dec 2008 22:09:31 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Roland <devzero@web.de>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Compress kernel modules on installation
In-Reply-To: <005401c96797$df055100$6602a8c0@bui.materna.com>
Message-ID: <alpine.LSU.2.00.0812262134270.12031@fbirervta.pbzchgretzou.qr>
References: <005401c96797$df055100$6602a8c0@bui.materna.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-12-26 21:23, Roland wrote:

> what about some "make modules_install_compressed" instead ?
>
> as i have run out of diskspace quite often when installing test kernels, i
> think we really need a feature like this.
>
> i`d also favour the makefile approach.
> why another kconfig option?
>
> jan`s patch looks clean and simple, but i think it`s a little bit intrusive...

Why so? module-ini

>
> regards
> roland
>
> ps:
> i`d use gzip without "-9" as this gives very little space savings. it mostly
> burns cpu and slows things down too much.
> ( see
> http://www.linuxjournal.com/files/linuxjournal.com/linuxjournal/articles/080/8051/8051f1.png

Here is one that is tailored for kernel modules:
http://tinyurl.com/8f2xta
Looks pretty much like the one from LJ but of course, .ko files
compress better than LJ :)
Oh well.
