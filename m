Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZD0MyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZD0MyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZD0MyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:54:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZD0MyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:54:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Mon, 27 Apr 2009 14:53:46 +0200
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-21-git-send-email-monstr@monstr.eu> <20090427095815.GA12323@infradead.org> <49F58A87.5020405@monstr.eu>
In-Reply-To: <49F58A87.5020405@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904271453.47038.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+A4wnZTyC1D6Qjf5JhU7Oi17OPDT/mFLLKbyq
 ZIRQwhd+MDMsUe+b7LGm87oCg84EyCli0QDieTCT/pQDoZeR41
 UT/r9SLEwb5iVppe0qatg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Michal Simek wrote:
> Long answer: in stat64 structure I wanted to find out more information
> about stat64 structure. I mean there are some variables and they have different
> types and I would like to know about more info.
> For example
> If make sense long long type for st_blocks. IMHO unsigned will be better.
> And I would like to create new stat64 structure where is not a fault for both noMMU/MMU version.
> In noMMU implementation is st_blocks unsigned long. Is it OK? or unsigned long long is better?
> 

I still think that there are major changes that should be done to the
Microblaze ABI. I actually did most of the work for this, but then you
beat be by getting it upstream first ;-)

I suppose it's much too late for 2.6.30 now, but maybe we can do one major
ABI change to microblaze by making the ABI totally generic in the next
merge window. I'll follow up with an RFC for this.

	Arnd <><
