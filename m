Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbZIWKUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbZIWKUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZIWKUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:20:41 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:35164 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZIWKUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:20:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19129.63017.997311.767124@pilspetsen.it.uu.se>
Date: Wed, 23 Sep 2009 12:19:21 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC Patch] kbuild: remove -Wdeclaration-after-statement
In-Reply-To: <20090923094034.23512.90809.sendpatchset@localhost.localdomain>
References: <20090923094034.23512.90809.sendpatchset@localhost.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang writes:
 > 
 > I got lots of "ISO C90 forbids mixed declarations and code" warnings
 > during compile today's kernel.
 > 
 > I think we can remove the gcc option '-Wdeclaration-after-statement'
 > now, since we already have C99 for 10 years. :)
 > 
 > Signed-off-by: WANG Cong <amwang@redhat.com>
 > Cc: Sam Ravnborg <sam@ravnborg.org>
 > 
 > ---
 > diff --git a/Makefile b/Makefile
 > index 433493a..038bda2 100644
 > --- a/Makefile
 > +++ b/Makefile
 > @@ -559,9 +559,6 @@ endif
 >  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 >  CHECKFLAGS     += $(NOSTDINC_FLAGS)
 >  
 > -# warn about C99 declaration after statement
 > -KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 > -
 >  # disable pointer signed / unsigned warnings in gcc 4.0
 >  KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)

This is more a matter of coding-style policy than C technicalities.

I happen to hate declarations at random places in the code, so I'd
prefer the offending code to be fixed instead.
