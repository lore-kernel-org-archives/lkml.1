Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZBZTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZBZTzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZBZTzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:55:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZBZTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:55:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Subject: Re: Page protection flags in linux on an x86 platform
Date: Thu, 26 Feb 2009 20:54:53 +0100
User-Agent: KMail/1.9.9
Cc: linux kernel <linux-kernel@vger.kernel.org>
References: <356809.23263.qm@web39808.mail.mud.yahoo.com>
In-Reply-To: <356809.23263.qm@web39808.mail.mud.yahoo.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902262054.53412.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Vm17PcYDAugfx0Fot5IlUdLDpexY1vIGrEII
 jUGixClHWytHKfmBpaTOkQE9SzwH18ADjBk+LRj6UJkV4blwt3
 r1SKFUi6K5Eu2z7VdSWoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Vinay Venkataraghavan wrote:
> I am trying to port some PPC code to x86 based linux. My question is that I am need to create some page mappings using remap_pfn_range. In the code for the PPC,
> the protection flags being specified are:
> 
> __pgprot(_PAGE_NO_CACHE | _PAGE_GUARDED);

To make your code portable, use pgprot_noncached(), which works on all
architectures.

	Arnd <><
