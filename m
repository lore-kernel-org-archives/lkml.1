Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZGVNuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZGVNuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZGVNuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:50:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbZGVNuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:50:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH/RFC] Move generated files to include/generated
Date: Wed, 22 Jul 2009 15:50:15 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       "linux-kbuild" <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20090721211040.GA7688@merkur.ravnborg.org> <20090722095818.GH6281@cr0.nay.redhat.com>
In-Reply-To: <20090722095818.GH6281@cr0.nay.redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907221550.15280.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX185SiW4Q2gnJNnfaW25MACmFvKAKyf7zqGYLdw
 MOxaKUU/CRSl0f3H5UlNeXERF2YF5ToA15029R8FOekhmMgYmJ
 aoteeYiXv7SR1CibSGP7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Amerigo Wang wrote:
> On Tue, Jul 21, 2009 at 11:10:40PM +0200, Sam Ravnborg wrote:
> >In 2.6.30 we introduced support for adding generated
> >files to a dedicated directory named "include/generated".
>
> Personally, I don't like this, I hate to see
> #include <generated/foo.h>

I think that moving the generated files to a common location
makes a lot of sense, but it seems easier to move them
to include/generated/linux/ or even to (generated/linux/) and
then add -Iinclude/generated/ to the gcc command line so
you don't need to actually change all the users.

For the files in asm/, you could either add a generated/asm
directory or move them to generated/linux/ and change the
users.

	Arnd <><
