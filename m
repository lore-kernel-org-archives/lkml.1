Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbZFXPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbZFXPbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbZFXPbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:31:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbZFXPbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:31:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Date: Wed, 24 Jun 2009 17:30:36 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Bird <tim.bird@am.sony.com>,
       Chris Simmonds <chris@2net.co.uk>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <4A33A7EC.6070008@gmail.com> <200906232355.34134.arnd@arndb.de> <2ea1731b0906232332n2488d452p27419eac7edab7e4@mail.gmail.com>
In-Reply-To: <2ea1731b0906232332n2488d452p27419eac7edab7e4@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906241730.37151.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+tmutT8ow4rNOciFZ6nyyBpruULl0giwuPlBN
 VIXgoBLAev+V2inbq+GtNnbE3H3Oka0RW4vE/0vgdLts0uL/2h
 xMyndbuvko1y+m80BZcew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Marco Stornelli wrote:
> > Actually, reading from /dev/mem is only valid on real RAM. If the nvram
> > is part of an IO memory mapping, you have to do mmap()+memcpy() rather
> > than read(). So dd won't do it, but it's still easy to read from user
> > space.
> 
> For "security" reasons pram reserve the region of memory with
> reserve_mem_region_exclusive().....

That will only prevent other device drivers from stepping on it,
/dev/mem does not care about mem_region reservations.

	Arnd <><
