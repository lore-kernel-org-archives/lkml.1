Return-Path: <linux-kernel-owner+w=401wt.eu-S1761142AbYFZPPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142AbYFZPPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYFZPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:14:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYFZPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:14:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 31/60] microblaze_v4: memory inicialization, MMU, TLB
Date: Thu, 26 Jun 2008 17:14:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-31-git-send-email-monstr@seznam.cz> <1214483429-32360-32-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-32-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261714.12967.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Y+S6mCnu76S4QO7C5sIZxOSn6hrYyNu6JdHI
 lxsdCI++cagHE9x2yUsf4UCi/9GPjK0esThoa4sSXN0aLYwmMM
 Z2tJns3VAVgxhgalzRuVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, monstr@seznam.cz wrote:

> +#include <linux/autoconf.h>

You should never need to include linux/autoconf.h anywhere,
just remove this.

> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include "../../../mm/internal.h"

Why do you need to include the internal.h file here?
If you have a good reason to do it, you should probably
add the symbol you need to a global header file.

	Arnd <><
