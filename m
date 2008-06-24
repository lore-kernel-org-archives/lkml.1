Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbYFXObe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbYFXObe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYFXOb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:31:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYFXOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:31:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] kbuild: prepare headers_* for arch/$ARCH/include
Date: Tue, 24 Jun 2008 16:31:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20080622220508.GA8957@uranus.ravnborg.org> <1214172524-9043-1-git-send-email-sam@ravnborg.org>
In-Reply-To: <1214172524-9043-1-git-send-email-sam@ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241631.18929.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19glWEpXdZG8P1Js+m9U3Hh46cS9NskfUjCXG4
 PsXZYxC8QxRa0n3yZqMBORHzQCY13FuTtWAvXEjwX3zMMndrht
 CRJlMJTVdRd0UWiKlkKmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Sam Ravnborg wrote:
> +# Do not try this architecture
> +drop="generic um ppc sparc64 cris"
> +
> +archs=$(ls ${srctree}/arch)
> +
> +for arch in ${archs}; do
> +	case ${arch} in
> +	um)        # no userspace export
> +		;;
> +	ppc)       # headers exported by powerpc
> +		;;

Note that arch/ppc is scheduled for removal with the 2.6.27 merge
window, so you may want to leave it out right away.

	Arnd <><
