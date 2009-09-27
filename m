Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZI0NTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZI0NTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 09:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZI0NTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 09:19:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:45159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZI0NTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 09:19:18 -0400
Date: Sun, 27 Sep 2009 15:19:42 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Message-ID: <20090927151942.1c6a010a@infradead.org>
In-Reply-To: <4ABF5E21.9080104@upmc.fr>
References: <4ABF4E36.4090703@upmc.fr>
	<4ABF5328.8020901@upmc.fr>
	<4ABF5E21.9080104@upmc.fr>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 14:44:17 +0200
Bernard Pidoux <bernard.pidoux@upmc.fr> wrote:

> I downloaded again linux-2.6.31.1.tar.bz2 and unpacked it.
> 
> ll /usr/src/linux-2.6.31.1/include/
> total 128
> drwxrwxr-x   3 root root  4096 2009-09-24 17:45 acpi/
> lrwxrwxrwx   1 root root     7 2009-09-27 14:34 asm -> asm-x86/
> drwxrwxr-x   3 root root  4096 2009-09-24 17:45 asm-generic/
> drwxr-xr-x   2 root root  4096 2009-09-27 14:34 asm-x86/
> 
> and
> 
> ll /usr/src/linux-2.6.31.1/include/asm/
> total 8
> -rw-r--r-- 1 root root 4890 2009-09-27 14:34 asm-offsets.h
> 
> So, I think that the kernel header problem is in the linux package,
> not in my system installation.

do not count until you have done "make headers_install"... there is
magic there that fixes up a bunch of things.
.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
