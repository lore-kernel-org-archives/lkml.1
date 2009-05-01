Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZEAM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZEAM1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZEAM1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:27:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEAM1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:27:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 07/27] asm-generic: add minimal cache description
Date: Fri, 1 May 2009 14:27:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <2d8ccc76119d2379859480dbb8f7562743a1de58.1241105648.git.arnd@arndb.de> <c1a198be0904302303h73c5168fi73f8dc24dc677965@mail.gmail.com>
In-Reply-To: <c1a198be0904302303h73c5168fi73f8dc24dc677965@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905011427.05099.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/U1EoUWPNvK+h8YFamQfD0VhA1+OUDQCd2v0K
 VJlmU23TF7jqzuAtXk++mbUKF0YoR8zntsdzc2DeNjFoQTq959
 tdAn17917BA43weHeGiXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Michal Simek wrote:
> > +#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
> > +       memcpy(dst, src, len)
> > +#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
> > +       memcpy(dst, src, len)
> 
> 
> IMHO these two macros will generate cast errors.

I did not see errors here, can you clarify? Note that despite the name,
they don't take a __user pointer. Maybe they should be inline functions
to make that more obvious.

	Arnd <><
