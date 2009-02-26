Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZBZAgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZBZAgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZBZAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:35:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57914 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZBZAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:35:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thiago Galesi <thiagogalesi@gmail.com>
Subject: Re: [patch 3/7] make MTD headers use strict integer types
Date: Thu, 26 Feb 2009 01:34:53 +0100
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20090225235138.062045835@arndb.de> <20090225235515.357247809@arndb.de> <82ecf08e0902251632k550156e5k471fc2cab5e9a0fd@mail.gmail.com>
In-Reply-To: <82ecf08e0902251632k550156e5k471fc2cab5e9a0fd@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902260134.54361.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19i4QHJ4idHP5aDdSvyADPwz/g0jt6sn31wdKl
 eQ3FmNe2Rz5wktMbCTLLaF55SWVhzYgfJ3eXhf6V682rk1nRCk
 1vRWwSY1vOiLgsthgwWhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Thiago Galesi wrote:
> I don't know if the idea is to do all at once, but MTD has a lot of
> things like u_char as well

I could not find any of those in the exported parts of the MTD headers,
only inside of #ifdef __KERNEL__, where it doesn't do any harm.

	Arnd <><
