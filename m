Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZH3NOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZH3NOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZH3NN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:13:59 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:43878 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZH3NN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=WB2L/CC4YHG+dy/BT9qzUenqBQ/YY1GlTaTYCDEBcaP2D+SUxtsA1UOgUlnqi3nJ9m
         UnMu6tDWlQl6ASQcNzwzOwM97EL971ibuOI3W7S15J47Ir8e5g+BfYdAgh3yDeuvtSX/
         osqT2HhMWl4CBR+i3MPF7tJdtMm/aD6Scszco=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: remove dead ncpfs list
Date: Sun, 30 Aug 2009 15:14:31 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Petr Vandrovec <vandrove@vc.cvut.cz>, linux-kernel@vger.kernel.org
References: <200908192219.09911.bzolnier@gmail.com> <1250719775.3407.91.camel@Joe-Laptop.home>
In-Reply-To: <1250719775.3407.91.camel@Joe-Laptop.home>
MIME-Version: 1.0
Message-Id: <200908301514.31208.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009 00:09:35 Joe Perches wrote:
> On Wed, 2009-08-19 at 22:19 +0200, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] MAINTAINERS: remove dead ncpfs list
> > 
> > On Saturday 01 August 2009 00:30:39 Mail Delivery Subsystem wrote:
> > > Delivery to the following recipient failed permanently:
> > > 
> > >      linware@sh.cvut.cz
> 
> Documentation/filesystems/ncpfs.txt looks pretty out of date
> as well.
> 
> "Linware's home site is klokan.sh.cvut.cz/pub/linux/linware"
> is dead.

OK, lets fix it while we are at it..

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ncpfs: remove dead URL from documentation

Noticed-by: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Andrew, could you also pick up my "ncpfs: fix wrong check in __ncp_ioctl()"
patch from 2009-07-28?  Thanks.

 Documentation/filesystems/ncpfs.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/Documentation/filesystems/ncpfs.txt
===================================================================
--- a/Documentation/filesystems/ncpfs.txt
+++ b/Documentation/filesystems/ncpfs.txt
@@ -7,6 +7,6 @@ ftp.gwdg.de/pub/linux/misc/ncpfs, but su
 will have it as well.
 
 Related products are linware and mars_nwe, which will give Linux partial
-NetWare server functionality.  Linware's home site is
-klokan.sh.cvut.cz/pub/linux/linware; mars_nwe can be found on
-ftp.gwdg.de/pub/linux/misc/ncpfs.
+NetWare server functionality.
+
+mars_nwe can be found on ftp.gwdg.de/pub/linux/misc/ncpfs.
