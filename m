Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYDWVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYDWVC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYDWVCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:02:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYDWVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:02:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: Microblaze Linux release
Date: Wed, 23 Apr 2008 23:01:45 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
References: <48020A21.4000404@seznam.cz> <480FA235.8000203@seznam.cz> <200804232257.04060.florian.fainelli@telecomint.eu>
In-Reply-To: <200804232257.04060.florian.fainelli@telecomint.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804232301.46764.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/5Bhnl2RnczqUBkHero0tL+I78r8/NN3kDrm7
 TVuYdzyMlNU5cNEiY9Viygu1tjCjrTkOJYqVZ2x4zAGp5hyxbu
 ZBJcrS7zPjCFCeHgR04HQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Florian Fainelli wrote:
> While reading the previous discussion, I wondered that keeping PCI would be a 
> good idea. I am personnaly using it for a custom design and would be glad 
> being able to continue using it.
> 
> If this represents too much work for you, we can probably add it later.
> 

The problem as far as I can see is that the existing header files
just don't work without a platform implementation.

I think it would be less confusing to leave them out. If you 
need PCI, it's probably easier to add new files for these
and get them working at the same time.

	Arnd <><
