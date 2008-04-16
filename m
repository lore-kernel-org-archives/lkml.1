Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbYDPHrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbYDPHrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYDPHrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:47:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:65349 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYDPHrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:47:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: Microblaze Linux release
Date: Wed, 16 Apr 2008 09:44:41 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
References: <48020A21.4000404@seznam.cz> <48059B92.7080601@seznam.cz> <18437.43836.175638.137415@cargo.ozlabs.ibm.com>
In-Reply-To: <18437.43836.175638.137415@cargo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804160944.42734.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19fK4JUaYLgqrnXSxjR8KNCLgqwKqBedR2RY+8
 RbNr7WWBYgfjx4NrST+Zh3NhMRLE4NZNtEQDUaeVoZsF71zIPq
 vQEfv1cv+axxttJIbnJdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Paul Mackerras wrote:
> Michal Simek writes:
> 
> > I think so. Sharing code among archs looks nice and this way is definitely
> > right. But starting with communication with PowerPC guys that this code I want
> > to use in case that this code is not in vanilla. This is not good start for
> > doing this.
> 
> I have a commit queued up that moves lmb.c into the top-level lib
> directory so other architectures can use it easily.  Dave Miller
> wanted this so he could use it for sparc64.  That will go into Linus'
> tree when the merge window opens and will be in 2.6.26.  So I don't
> see any reason why microblaze couldn't use the LMB stuff.
> 

Right, fair enough. I was mostly objecting to the idea of creating another
copy of the lmb code when bootmem should be sufficient for what microblaze
needs. Using the code from lib/lmb.c sounds fair enough when it's already
there.

One more reason for the microblaze kernel to base on top of linux-next
instead of mainline.

	Arnd <><
