Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbZCTTHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbZCTTHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZCTTHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:07:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49492 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZCTTG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WgSHxPyxYVkf7d49SQ6E0jdUDRSF88V8gErrurtYmr/VqCcjbGm4im6ax7Pb4oZDQ+
         WTRQh4qOK1Ot8wOcWBllHAoUFKd+uJd6EFPpkgAGNodZ+ouJNmXlDykK1ZSs62foTQhb
         1r6jac6oPvZc2XYOzlgSD+m4SSOXqSNr7l8Y8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] MAINTAINERS: move old ide-{floppy,tape} entries to CREDITS
Date: Fri, 20 Mar 2009 19:46:25 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-next-20090319; KDE/4.2.1; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gadi Oxman <gadio@netvision.net.il>,
       Paul Bristow <paul@paulbristow.net>
References: <200903182201.32668.bzolnier@gmail.com> <20090319053919.GA24137@liondog.tnic>
In-Reply-To: <20090319053919.GA24137@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903201946.26121.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009, Borislav Petkov wrote:
> On Wed, Mar 18, 2009 at 10:01:32PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] MAINTAINERS: move old ide-{floppy,tape} entries to CREDITS
> > 
> > Ben Hutchings noticed that MAINTAINERS somehow still contain old
> > ide-{floppy,tape} entries.  Fix it by moving them to CREDITS (kudos
> > to Gadi and Paul for all the early hard work on ide-{floppy,tape}).
> > 
> > Cc: Gadi Oxman <gadio@netvision.net.il>
> > Cc: Paul Bristow <paul@paulbristow.net>
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Borislav, maybe it would make sense to rename IDE/ATAPI CDROM DRIVER
> > entry to IDE/ATAPI DRIVERS one nowadays (you're the one doing most of
> > ATAPI work anyway :)?
> 
> ... after you, of course :).
> 
> Fine with me. The easiest would be if you fold the change into the same patch.

OK, done!

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] MAINTAINERS: move old ide-{floppy,tape} entries to CREDITS (take 2)

Ben Hutchings noticed that MAINTAINERS somehow still contain old
ide-{floppy,tape} entries.  Fix it by moving them to CREDITS (kudos
to Gadi and Paul for all the early hard work on ide-{floppy,tape}).

v2:
Rename IDE/ATAPI CDROM DRIVER entry to IDE/ATAPI DRIVERS one.

Cc: Gadi Oxman <gadio@netvision.net.il>
Cc: Paul Bristow <paul@paulbristow.net>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 CREDITS     |    9 +++++++++
 MAINTAINERS |   15 +--------------
 2 files changed, 10 insertions(+), 14 deletions(-)

Index: b/CREDITS
===================================================================
--- a/CREDITS
+++ b/CREDITS
@@ -495,6 +495,11 @@ S: Kopmansg 2
 S: 411 13  Goteborg
 S: Sweden
 
+N: Paul Bristow
+E: paul@paulbristow.net
+W: http://paulbristow.net/linux/idefloppy.html
+D: Maintainer of IDE/ATAPI floppy driver
+
 N: Dominik Brodowski
 E: linux@brodo.de
 W: http://www.brodo.de/
@@ -2642,6 +2647,10 @@ S: C/ Mieses 20, 9-B
 S: Valladolid 47009
 S: Spain
 
+N: Gadi Oxman
+E: gadio@netvision.net.il
+D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
+
 N: Greg Page
 E: gpage@sovereign.org
 D: IPX development and support
Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2173,25 +2173,12 @@ L:	linux-ide@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
 S:	Maintained
 
-IDE/ATAPI CDROM DRIVER
+IDE/ATAPI DRIVERS
 P:	Borislav Petkov
 M:	petkovbb@gmail.com
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 
-IDE/ATAPI FLOPPY DRIVERS
-P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
-W:	http://paulbristow.net/linux/idefloppy.html
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
-IDE/ATAPI TAPE DRIVERS
-P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 IDLE-I7300
 P:	Andy Henroid
 M:	andrew.d.henroid@intel.com
