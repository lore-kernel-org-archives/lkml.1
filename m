Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYFZPf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYFZPf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYFZPfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:35:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:61013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYFZPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:35:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or redirect to asm-generic
Date: Thu, 26 Jun 2008 17:35:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-48-git-send-email-monstr@seznam.cz> <1214483429-32360-49-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-49-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261735.12738.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+kDBFSMPUYw2iUK3N0k5dyyWiv+2aIQF4WMq/
 F1PmO8bytZc9keCotDNdoQDn+pL31z9QbghEJLMyjvEjgfk4AI
 5voUbktdfgM4Ammxa6/gQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, monstr@seznam.cz wrote:
> +
> +#ifndef _ASM_MICROBLAZE_NAMEI_H
> +#define _ASM_MICROBLAZE_NAMEI_H
> +
> +#ifdef __KERNEL__
> +
> +/* This dummy routine maybe changed to something useful
> + * for /usr/gnemul/ emulation stuff.
> + * Look at asm-sparc/namei.h for details.
> + */
> +#define __emul_prefix() NULL
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* _ASM_MICROBLAZE_NAMEI_H */

Could you move this to asm-generic? Note that the comment is wrong,
asm-sparc doesn't actually implement it any more, only ia64, mips and
arm have an implementation that actually does something interesting
here.

	Arnd <><
