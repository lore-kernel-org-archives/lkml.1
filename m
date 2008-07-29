Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbYG2Tvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbYG2Tvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYG2Tvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:51:33 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:8366 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYG2Tvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=GrA1/sq5mlYpJJSBVjaTGz2q1p0s9MdKrgq/dqgOPqAyck1K14o201DGr7qWBa43aZ
         QDhp63aVY/waR6ca3SivordSJQSjtreJYnP6tEsHuK3nQUMvgQjpxFgcWEtU81UbQ/y8
         uL85Zd0qpuJCCOLqusoqIbFxZEKhyfDSFj4ig=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] remove unneeded #include <linux/ide.h>'s
Date: Tue, 29 Jul 2008 21:43:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080727130448.GK9301@cs181140183.pp.htv.fi> <200807271632.16417.bzolnier@gmail.com> <20080729164831.GC23951@cs181140183.pp.htv.fi>
In-Reply-To: <20080729164831.GC23951@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807292143.23094.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008, Adrian Bunk wrote:
> On Sun, Jul 27, 2008 at 04:32:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 27 July 2008, Adrian Bunk wrote:
> > > The sh systemh_defconfig currently fails to build with the following 
> > > error:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > >   CC      arch/sh/boards/renesas/systemh/irq.o
> > > In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/boards/renesas/systemh/irq.c:16:
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/ide.h:645: error: 'CONFIG_IDE_MAX_HWIFS' undeclared here (not in a function)
> > > make[2]: *** [arch/sh/boards/renesas/systemh/irq.o] Error 1
> > 
> > Please also fix the source root of the problem:
> > 
> > arch/sh/boards/renesas/systemh/irq.c should have no bussiness in
> > including include/linux/ide.h (which is for drivers/ide/ _only_)
> >...
> 
> ide-scsi.c and the mediabay stuff might qualify as exceptions?

Yes, they are exceptions confirming the rule. :)

> For the rest a patch is below (on top of your #include <linux/hdreg.h> 
> removal patch).

applied
