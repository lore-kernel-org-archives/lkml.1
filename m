Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYDNGzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYDNGzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYDNGzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:55:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52103 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYDNGza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:55:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Microblaze Linux release
Date: Mon, 14 Apr 2008 08:55:14 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
References: <48020A21.4000404@seznam.cz> <200804140538.30268.arnd@arndb.de> <4802E749.2040809@zytor.com>
In-Reply-To: <4802E749.2040809@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140855.14892.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+AssCtgYFZKKP/IpY2dZLTADM7mPP3dSmingS
 IwGjKocs/s01y4MFLGvCwp/InrB6mvZLgSFyuha8WOaaCvqFCT
 eWEqQIfRS1AHmJrFXac/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, H. Peter Anvin wrote:
> Arnd Bergmann wrote:
> > 
> > One of the things I always wanted to have is a common location for all the
> > things that get duplicated verbatim into each new architecture, like all
> > the include/asm/{fcntl,ioctls,ipcbuf,mman,poll,posix_types,sem_buf}.h and
> > others that define part of the syscall ABI.
> > 
> 
> include/asm-generic

Sure. Halfway through writing my sentence, I wanted to suggest arch/generic
for the stuff in there that has the potential of being unified, but then
realized how little there is of that, and that it may just as well go into
the top-level mm/, kernel/, lib/ etc, as we have done in the past.

	Arnd <><
