Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYDNIfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYDNIfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYDNIfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:35:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbYDNIfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:35:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 3/3] OLPC: gxfb/lxfb: add DCON panel modes to framebuffer drivers
Date: Mon, 14 Apr 2008 10:33:58 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, jordan.crouse@amd.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
References: <20080414035302.794dcd7a@ephemeral>
In-Reply-To: <20080414035302.794dcd7a@ephemeral>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804141033.59998.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+eze5X/d2pU3BoCNW/uH0E1alKUjuAKU2s5zK
 JJEq8GHr5Tq/a7Zv3ihj6JeWyfA2eVubjKpW3UNGok00gG5sea
 hwZsN+Y3UIlVKDVUleEiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Andres Salomon wrote:
> Since there's no way to autodetect panel modes, we're forced to hardcode
> them in the driver and add a big fat #ifdef.  The OLPC DCON needs a
> specific mode line (at 1200x900).  This adds it to both gxfb and lxfb.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Since the XO is based on Open Firmware, shouldn't the panel size really be
a property in the device tree that can be read by this driver?

	Arnd <><
