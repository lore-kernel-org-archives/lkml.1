Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYFZRpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYFZRpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYFZRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:45:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbYFZRpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:45:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or redirect to asm-generic
Date: Thu, 26 Jun 2008 18:38:32 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261735.12738.arnd@arndb.de> <20080626162118.GG22025@cs181140183.pp.htv.fi>
In-Reply-To: <20080626162118.GG22025@cs181140183.pp.htv.fi>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261838.33787.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19WdSVzjKNv9jbR9liSEQx8ATUwqe0i4OG7w9E
 FL/7iTeUI4uwezOijXEMs+P63LmOwjuE/OpXs+Ip6JrFhnmB6u
 zdwUr+38QFpRBIUfBkaZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Adrian Bunk wrote:
> The comment could be nuked (as well as the #ifdef __KERNEL__), but for 
> the one #define an asm-generic header would IMHO be overkill.

I agree that it doesn't technically make sense to have a one-line
asm-generic header, but I like the idea of reducing the number of
asm/*.h files that actually contain anything other that
#include <asm-generic/$FILE.h>, mostly for documentation purposes.

If we can eventually agree on a way to get rid of the requirement
for explicit redirection, we can remove a larger number of source
files completely.

	Arnd <><
