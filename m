Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbZENH2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbZENH2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbZENH2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:28:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbZENH2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:28:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 00/16] asm-generic headers, v4
Date: Thu, 14 May 2009 09:28:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, Chen Liqin <liqin.chen@sunplusct.com>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de> <20090514164521.c2b61893.sfr@canb.auug.org.au>
In-Reply-To: <20090514164521.c2b61893.sfr@canb.auug.org.au>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905140928.01861.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19+tn/c2NwVHzaV6FppjbemK7kT2rSqf8Aojbv
 p2gPn/hoHV3Im2nqzly09MqzXJS2vjVlWGKNQlDJWkIC+COL3B
 K1WPyE5NfHDahrGSnO2IQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009, Stephen Rothwell wrote:
> Hi Arnd,
> 
> On Wed, 13 May 2009 22:56:23 +0000 Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Stephen, can you add
> > git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic next
> > to linux-next?
> 
> I will try this tomorrow.  It will be interesting to see just how many
> conflicts we get.

Thanks!

I've tried to make this patch set as non-invasive as possible, basically
just adding files and making single line changes to existing files
where necessary. I've never seen conflicts when I tried merging
with linux-next/master.

In the beginning, I was thinking about doing one series per file,
adding the asm-generic version in one patch and changing the per-arch
versions to use it in follow-on patches.
Hopefully, the way I'm doing it now turns out to be less time consuming,
as I can add all the generic headers once without impacting any of the
architectures, and the next patches can easily be done in the
arch maintainer tree for all files at once.

	Arnd <><
