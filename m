Return-Path: <linux-kernel-owner+w=401wt.eu-S1762617AbYDOVUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762617AbYDOVUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932732AbYDOVTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:19:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:30875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550AbYDOVTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hoPQjo4BiF6BgXF9Cml979J1ZzeHTvVaSxDgSwGGyE2QHjH9jNKAl8mdj1r1dMJkn7NxlKmnr7MGbEkjLKOxKUGIucQu+M6m31wcC5bKzxkz9LjBb4b68Lrkbr1dGmIPjv05vywAbDh874I9qWR8uJymTMISCTctcSRgU0/fzXI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [2.6 patch] avr32 mustn't select HAVE_IDE
Date: Tue, 15 Apr 2008 22:09:19 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, hskinnemoen@atmel.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080414141650.GD6695@cs181133002.pp.htv.fi> <20080414175457.GB15028@uranus.ravnborg.org>
In-Reply-To: <20080414175457.GB15028@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804152209.19837.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Sam Ravnborg wrote:
> On Mon, Apr 14, 2008 at 05:16:50PM +0300, Adrian Bunk wrote:
> > There's a libata based PATA driver for avr32, but no support for 
> > drivers/ide/ on avr32.
> > 
> > This patch fixes the following compile error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC [M]  drivers/ide/ide-cd.o
> > In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/ide-cd.c:37:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/ide.h:209:21: error: asm/ide.h: No such file or directory
> > make[3]: *** [drivers/ide/ide-cd.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Obviously correct.
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

applied
