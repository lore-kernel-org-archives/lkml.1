Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZHMR2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZHMR2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZHMR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:28:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZHMR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:28:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schnell <mschnell@lumino.de>
Subject: Re: implementing Futex
Date: Thu, 13 Aug 2009 19:28:16 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de>
In-Reply-To: <200908131839.41803.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131928.16759.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19yINU5lYD8sdtCSqv7IEgwH9vIYv8+qBUaEaP
 LLuTD4t1dENaE+pqvDCuk/z3m/5rah31naqqiMYrVy7gtvJUhV
 lbR7G56ixILR9FFRQsMtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Arnd Bergmann wrote:
> On Thursday 13 August 2009, Michael Schnell wrote:
> > I am planning to implement a Futex on the upcoming MMU-enabled NIOS
> > architecture.
> 
> Ah, I'm always interested in new architectures. Are you already using
> all the asm-generic header files that we have in 2.6.31? Please tell
> me if you find problems with those.

FWIW, I just had a look at git://sopc.et.ntust.edu.tw/git/linux-2.6.
Is that the one you are working on?

The code there is still based on 2.6.30, which does not yet have
all the new header file. When you (or someone else) do the port
to 2.6.31, please go through each header file and see if you can
change it to use the asm-generic version.

For most of the exported files, that will mean a user space ABI
change, so you need to rebuild your libc, but it will significantly
reduce the amount of (duplicate) code in the architecture tree.

	Arnd <><
