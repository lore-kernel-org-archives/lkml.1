Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZELAab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZELAab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbZELA3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:29:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56679 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbZELA3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:29:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [microblaze-uclinux] [PATCH 12/12] microblaze: use generic dma-mapping-broken.h
Date: Tue, 12 May 2009 02:29:35 +0200
User-Agent: KMail/1.9.9
Cc: microblaze-uclinux@itee.uq.edu.au, "Michal Simek" <monstr@monstr.eu>,
       linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <20090511232019.927138561@arndb.de> <20090511232345.859696820@arndb.de>> <20090511235954.A1CD414D0050@mail215-wa4.bigfish.com>
In-Reply-To: <20090511235954.A1CD414D0050@mail215-wa4.bigfish.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905120229.36047.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19mNjdFXOaYGjQ+VVff6HofZb5YnUT8gfLY/Yd
 dth0ith9ovvg/ncyikn8wxlC4PoFI/REfQMd71YnF69UEVEDtW
 e8mesXmrQ5x+YLYzh/IdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Stephen Neuendorffer wrote:
> 
> Gah... considering the ll_temac needs this, it should get implemented
> ASAP...
> (Yeah, I know... just not enough hours in the day.)
> 

FUJITA Tomonori has just posted an asm-generic version of dma-mapping.h,
which is half complete. For microblaze, it should be easy to add the
missing functions, basically falling back on get_free_pages for all
allocations and on page_to_phys for the actual mapping, as in
arch/powerpc/kernel/dma.c.

	Arnd <><
