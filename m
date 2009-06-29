Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbZF2Q3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbZF2Q3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZF2Q26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:28:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZF2Q25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:28:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 0/6] score cleanups
Date: Mon, 29 Jun 2009 18:28:57 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <OF25C38F64.D04F8269-ON482575E4.003CD5CE-482575E4.003E9943@sunplusct.com>
In-Reply-To: <OF25C38F64.D04F8269-ON482575E4.003CD5CE-482575E4.003E9943@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200906291828.57948.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/RtgT97Q/xogBfpqgIc7bRfGoV7keRdCeahtg
 nqnZZpXd+keT0GdnQouknV4HyTkWF5EPn3kZI1QBwNpBEvBUJx
 J3jpSbHyShbwxrXaAM5aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, liqin.chen@sunplusct.com wrote:
> Arnd Bergmann <arnd@arndb.de> 写于 2009-06-27 22:08:12:
> 
> > Hi Liqin,
> > 
> > I've gone over your code a bit with sparse and some clues,
> > cleaning up some areas that stuck out.
> > 
> > Please check that these make sense.
> 
> Hi Arnd,
> 
> Code updating had finished and verified.

Ok, I've pushed out my original patches now. Unfortunately,
the way you sent back the patches was not helpful. Your mail
client still suffers from line-wrapping, which makes it impossible
to apply and you dropped all the changelog entries that I wrote.

It took me longer to split the changes into logical patches
with an appropriate changelog, so they really should not
be merged again. If you don't have a comment for the patches,
a better action would have been to reply with 'Acked-by: 
Chen Liqin <liqin.chen@sunplusct.com>'.

> 
> Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Here you mixed up the order of the 'Signed-off-by:'-lines.
If you forward a patch from someone else, you should always
put your own S-O-B after all the the others, not before them.
of(u32))) {

> @@ -151,7 +152,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char 
> *strtab,
>  /* Given an address, look for it in the module exception tables. */
>  const struct exception_table_entry *search_module_dbetables(unsigned long 
> addr)

This is one example of how the line wrapping broke the patch. It's basically
impossible to apply and test if the patch is broken like this.

	Arnd <><
