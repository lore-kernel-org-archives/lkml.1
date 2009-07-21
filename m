Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZGULc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZGULc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZGULcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:32:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZGULcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:32:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Date: Tue, 21 Jul 2009 13:31:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       sds@tycho.nsa.gov, jmorris@namei.org, spender@grsecurity.net,
       dwalsh@redhat.com, cl@linux-foundation.org, arjan@infradead.org,
       alan@lxorguk.ukuu.org.uk
References: <1248132223.2654.278.camel@localhost> <20090721041311.GE11051@bombadil.infradead.org>
In-Reply-To: <20090721041311.GE11051@bombadil.infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907211331.50196.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18mSe68zeOonmy/AN5q8gRwoBPbYzit1HiYQb7
 +u+p/6eh11FKMaVFmhyyPToGrA6b/3xxj4X+yXsU5z0BxgzrJb
 8Tedfw+DyOkScJcnU68sA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Kyle McMartin wrote:
> 
> Why do we not add a personality flag for this? With that, at least you
> could require a harmless setuid wrapper for wine that just set the
> personality bits and dropped root.

I thought the MMAP_PAGE_ZERO personality bit was exactly what Brad
was using in his demonstration. We don't need to define a new bit,
just use the one that's there ;-).

Then again, setting personality flags does not require root permissions
normally, so it's not an extremely strong protection, unless you also
start requiring CAP_SYS_RAWIO for setting MMAP_PAGE_ZERO.

	Arnd <><
