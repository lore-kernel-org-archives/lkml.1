Return-Path: <linux-kernel-owner+w=401wt.eu-S1764790AbYEATRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764790AbYEATRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761194AbYEATRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:17:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbYEATRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:17:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <jwilliams@itee.uq.edu.au>
Subject: Re: microblaze syscall list
Date: Thu, 1 May 2008 21:17:10 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, microblaze-uclinux@itee.uq.edu.au,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <48151726.9000204@itee.uq.edu.au> <200804281431.26570.arnd@arndb.de>
In-Reply-To: <200804281431.26570.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805012117.12991.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/b/6udfAdnWZebi4NYLL6mXClKvSn9qhYBgg1
 0rTJOT3al5t0MgFIWHCTmOPS5r3uUnnekR2K8uCfLxMA12rZkN
 H7g3UjJYGRWwk8NwaUpow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Arnd Bergmann wrote:
> How about this strategy then:
> * Change all the data types and syscall numbers in the -for-2.6.27
> branch to only include the minimal set, and a modern ABI
> * Add the old interfaces as an out-of-tree patch that adds source
> level compatibility with the old libc, but does not modify any
> of the new interfaces, so that a patched kernel can run all binaries
> built for the upstream version.
> * phase out the old source interface gradually, as all users update
> their libc source code.

Any news on this from the microblaze people? Have you made up your mind
on what route you want to go?

	Arnd <><
