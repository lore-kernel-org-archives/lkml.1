Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZD0M4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZD0M4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZD0M41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:56:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbZD0M41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:56:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Mon, 27 Apr 2009 14:55:49 +0200
User-Agent: KMail/1.9.9
Cc: monstr@monstr.eu, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271437.09273.arnd@arndb.de> <20090427124839.GA9668@uranus.ravnborg.org>
In-Reply-To: <20090427124839.GA9668@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904271455.50611.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX189jujvbvpHGH8mBSbgRKNRez8KDXg9IYOeS5p
 7r0+UEsIByDtnD/kqIfJ3c1+a/MD2a7R3UU6ktby8ujDITmvJx
 kr85DyU+J9P3GHtYRBITg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Sam Ravnborg wrote:
> The reason I had was:
> 1) consistency. We say that we should use the width specific types in our interfaces
> 2) readability. We expect to see the kernel types used - so we know then and does not
>                 start to wonder why we did not use them here.
> 3) documentation. The __{u,s}{32,64} documents the size better than "unsigned int" / long long" etc.
> 
> But no technical atrong arguments.

Well, these are good points, I guess. I'm about to post a series
that adds generic headers for all the ABI. I'm not adapting them
all for this, but it might be a good idea, considering that the
asm-generic headers have a documentation character as well, meaning
that they should serve as an example for how to write new headers.

	Arnd <><
