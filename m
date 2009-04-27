Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZD0Mhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZD0Mhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZD0Mhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:37:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:62854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZD0Mhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:37:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Mon, 27 Apr 2009 14:37:08 +0200
User-Agent: KMail/1.9.9
Cc: monstr@monstr.eu, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271357.01681.arnd@arndb.de> <20090427121556.GA9469@uranus.ravnborg.org>
In-Reply-To: <20090427121556.GA9469@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271437.09273.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Uo7REH1W4nFQl3t2BM8QS9Esl5tApMr9NiSe
 OS3DfHCxcVjnO7WmUJqUFCnW8/Fgasg/URko0etBRFyauIXJIF
 +BsUxaHzXR5N7KE0uoXLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Sam Ravnborg wrote:
> Why not use __u64/__u32 (and s32/s64 where appropriate)?
> Historical baggage or a techncal reason?

Yes, purely historical reasons: all architectures currently
use the simple C types rather than __u32 in stat.h.

I don't think it makes a difference either way, so I'd
leave it like this unless you find a good reason for
changing.

	Arnd <><
