Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZI0Lg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZI0Lg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZI0Lg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:36:27 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:38617 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZI0Lg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:36:26 -0400
Message-ID: <4ABF4E36.4090703@upmc.fr>
Date: Sun, 27 Sep 2009 13:36:22 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a user space application.

Here is Gcc error message :

gcc -Wall -Wstrict-prototypes -O2 -ggdb2 -funsigned-char  -D__LINUX__ -Wformat-security -D_FORTIFY_SOURCE=2 -DPROTOTYPES -I../lib -I/usr/src/linux/include -fstack-check -fstack-protector-all -c listen.c
Dans le fichier inclus à partir de /usr/include/asm/types.h:4,
          à partir de /usr/src/linux/include/linux/types.h:4,
          à partir de /usr/src/linux/include/linux/if_ether.h:24,
          à partir de /usr/include/net/ethernet.h:27,
          à partir de listen.c:21:
/usr/src/linux/include/asm-generic/int-ll64.h:11:29: erreur: asm/bitsperlong.h : Aucun fichier ou dossier de ce type
listen.c: In function ‘main’:



On Sun, 27 Sep 2009 13:16:41 +0200
Bernard Pidoux <bernard.pidoux@upmc.fr> wrote:

> The problem is that when I compile an application that never 
> caused any problem before I get an error due to incorrect reference
> to <asm/bitsperlong>

is this a userspace application? or some kernel module?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org


