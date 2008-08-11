Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYHKP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYHKP1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYHKP1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:27:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYHKP1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:27:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [RFC 2/3] powerpc: export all symbols from the definition file
Date: Mon, 11 Aug 2008 17:27:07 +0200
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-arch@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
References: <200808111606.44103.arnd@arndb.de> <200808111617.53305.arnd@arndb.de> <Pine.LNX.4.64.0808111653170.3030@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0808111653170.3030@vixen.sonytel.be>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808111727.07720.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+pdtZFtIQdfgEGHdJ8uVpcge1pVxPzfGmCzUK
 ZQ7ITmoMM+Jx1wXtxAofeV+PAjpQAdi4FsTG+dGimsJb7usk8I
 4/HFKlRI34ztSIwIz2HaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Geert Uytterhoeven wrote:
> >  drivers/macintosh/adb.c              |    5 +++++
> >  drivers/macintosh/via-cuda.c         |    3 +++
> 
> I think these 2 belong to patch 3?

I tried to come up with other ways of splitting up the patch,
but since these come from ppc_ksyms, it makes sense to keep
them with the rest.

Maybe I could split the exports for C functions from those
in assember files that depend on patch 1.

	Arnd <><
