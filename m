Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbXJ2TZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbXJ2TZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXJ2TYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:24:55 -0400
Received: from mail.trixing.net ([87.230.125.58]:48536 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXJ2TYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:24:55 -0400
Message-ID: <4726337B.1080608@l4x.org>
Date: Mon, 29 Oct 2007 20:24:43 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Working frv toolchain?
References: <4725B553.4060502@l4x.org> <4220.1193663179@redhat.com>
In-Reply-To: <4220.1193663179@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jdi@l4x.org
X-SA-Exim-Scanned: No (on mail.trixing.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Jan Dittmer <jdi@l4x.org> wrote:
> 
>> With gcc 4.0.0 and binutils 2.15.94 I get:
> 
> I'm using gcc 4.1.2.

4.1.2 together with 2.17.50 gives me with a i386 cross
compiler:

   CC      arch/frv/mm/dma-alloc.o
/usr/src/xtest/linux-2.6/arch/frv/mm/dma-alloc.c: In function 
'consistent_alloc':
/usr/src/xtest/linux-2.6/arch/frv/mm/dma-alloc.c:66: error: impossible 
constraint in 'asm'
make[2]: *** [arch/frv/mm/dma-alloc.o] Error 1
make[1]: *** [arch/frv/mm] Error 2
make: *** [sub-make] Error 2

Known bug or toolchain problem?

Jan

