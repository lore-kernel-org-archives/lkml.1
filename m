Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZI0QuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZI0QuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZI0QuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:50:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:51134 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZI0QuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:50:21 -0400
Date: Sun, 27 Sep 2009 18:50:45 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Message-ID: <20090927185045.63907fbd@infradead.org>
In-Reply-To: <4ABF92D7.609@upmc.fr>
References: <4ABF4E36.4090703@upmc.fr>
	<4ABF5328.8020901@upmc.fr>
	<4ABF5E21.9080104@upmc.fr>
	<20090927151942.1c6a010a@infradead.org>
	<4ABF92D7.609@upmc.fr>
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

On Sun, 27 Sep 2009 18:29:11 +0200
Bernard Pidoux <bernard.pidoux@upmc.fr> wrote:

> If it was supposed to install bitsperlong.h in /asm/ magic did not
> work.
> 
> I am a little bit puzzled for the script writes 
> 
>   INSTALL include/asm (53 files)
> 
> and I can still only list one file in that directory. 


> [root@f6bvp-11 linux-2.6.31.1]# ll include/asm/
> total 8
> -rw-r--r-- 1 root root 4890 2009-09-27 14:34 asm-offsets.h


ls /usr/include/asm

that's where it ends up.

the kernel's "include/asm" is supposed to be empty or near empty.
