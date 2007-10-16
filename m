Return-Path: <linux-kernel-owner+w=401wt.eu-S933725AbXJPOWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbXJPOWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbXJPOW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:22:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60133 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbXJPOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:22:28 -0400
Date: Tue, 16 Oct 2007 16:22:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: In response to kernel compression e-mail a few months ago.
In-Reply-To: <200710161419.07975.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710161608200.10197@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan>
 <20071014205008.GZ8181@ftp.linux.org.uk> <Pine.LNX.4.64.0710141650500.12466@p34.internal.lan>
 <200710161419.07975.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 16 2007 14:19, Denys Vlasenko wrote:
>Sizes in Kb again:
>
>32392 linux-2.6.16.17.tar.7z
>33520 linux-2.6.16.17.tar.lzma
>
>P.S. sorting files by extension in tarball generally helps, but in case
>of Linux kernel, they are all C code anyway, so no measurable gain there.

Extension is not all so interesting because, as you point out,
most of it is C code, and .h files are mostly like .c in that they
have structs and function prototype keywords. But sorting by
name buys:

-rw-r--r--  1 jengelh users 45477128 Oct 12 18:47 linux-2.6.23.1.orig.tar.bz2
-rw-r--r--  1 jengelh users 45560647 Oct 16 16:18 linux-2.6.23.1.new.tar.bz2

(actually, `find "$@" -print0 | sort -z | tar -T- --null --no-r --owner=root
--group=root -cvjf "$output";` was used)
