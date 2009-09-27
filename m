Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZI0Sd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZI0Sd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZI0Sd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:33:56 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:55100 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZI0Sd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:33:56 -0400
Message-ID: <4ABFB00E.7080207@upmc.fr>
Date: Sun, 27 Sep 2009 20:33:50 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: arnd@arndb.de
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
References: <4ABF4E36.4090703@upmc.fr> <200909271658.18646.arnd@arndb.de>
In-Reply-To: <200909271658.18646.arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks for the solution to my issue.
As I maintain the application, it was easy to perform the change
to Makefile and it worked fine.

Best regards,

Bernard Pidoux

arnd@arndb.de a écrit :
> On Sunday 27 September 2009 11:36:22 Bernard Pidoux wrote:
>> gcc -Wall -Wstrict-prototypes -O2 -ggdb2 -funsigned-char  -D__LINUX__ -Wformat-security -D_FORTIFY_SOURCE=2 -DPROTOTYPES -I../lib -I/usr/src/linux/include -fstack-check -fstack-protector-all -c listen.c
>> Dans le fichier inclus à partir de /usr/include/asm/types.h:4,
>>           à partir de /usr/src/linux/include/linux/types.h:4,
>>           à partir de /usr/src/linux/include/linux/if_ether.h:24,
>>           à partir de /usr/include/net/ethernet.h:27,
>>           à partir de listen.c:21:
>> /usr/src/linux/include/asm-generic/int-ll64.h:11:29: erreur: asm/bitsperlong.h : Aucun fichier ou dossier de ce type
>> listen.c: In function ‘main’:
>>
> 
> The problem is the '-I/usr/src/linux/include' part of the gcc command line.
> See http://kernelnewbies.org/KernelHeaders for why this is wrong.
> You should notify the maintainer of the package to fix this by removing
> this option. The headers in /usr/include/ are sufficient to build user
> code.
> 
> 	Arnd <><
> 

