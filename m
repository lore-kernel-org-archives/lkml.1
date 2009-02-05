Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZBEVft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZBEVft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZBEVeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:34:50 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:40866 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZBEVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=vNZwgpEWX1L8886lpDXrOhPvTI6KRV98F5t5V8NsjCFpT+xkFy4DvBQhwecZMBi5y5
         TXywYOl16QgIYDIqIbnrrxlVk1rt8VnYqwUDvrI93anC7mGhA/zqniLRcUeOh0buaqPr
         4mu82pBSMjXEQ2iF8Xw8Mhv3xf9R4oCE9iwYc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 01/15] ide: include <asm/ide.h> only when needed
Date: Thu, 5 Feb 2009 22:14:31 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc3-next-20090204; KDE/4.1.4; i686; ; )
Cc: geert@linux-m68k.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, apw@canonical.com
References: <20090201174916.19144.11318.sendpatchset@localhost.localdomain> <200902021927.25177.bzolnier@gmail.com> <20090204.232006.01916235.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090204.232006.01916235.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902052214.31483.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Atsushi Nemoto wrote:
> On Mon, 2 Feb 2009 19:27:25 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > > > +#include <asm/ide.h>
> > > 
> > > Did you try checkpatch.pl?
> > 
> > Sure.
> > 
> > This driver uses stuff from <asm-mips/ide.h>.
> > 
> > [ I guess I could put '-mips' there to silence warnings on tx493{8,9}.c,
> >   however I don't know of the way to get rid of ide-io-std.c's one... ]
> 
> BTW, tx4939ide_{in,out}put_data_swap and
> tx4939ide_{in,out}put_data_swap do exactly same thing.
> 
> If byte-swapped version of ide_{in,out}put_data() were available by
> ide core, they can be used instead.  The byte-swapped version of
> default_tp_ops would much helps such queer big-endian platforms.  Is
> it worth to bloat ide core? ;-)

Seems to be a good idea and it may also help some other host drivers
(ide-h8300.c?).

Thanks,
Bart
