Return-Path: <linux-kernel-owner+w=401wt.eu-S933581AbZLOTam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbZLOTam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933447AbZLOTaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:30:16 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:27981 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbZLOT37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:29:59 -0500
Date: Tue, 15 Dec 2009 11:29:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] fs: fix compat_ioctl build for CONFIG_BLOCK=n
Message-Id: <20091215112934.020e5648.randy.dunlap@oracle.com>
In-Reply-To: <200912142016.13631.arnd@arndb.de>
References: <20091214165927.c08c4784.sfr@canb.auug.org.au>
	<20091214091005.b4df65d9.randy.dunlap@oracle.com>
	<200912142016.13631.arnd@arndb.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4B27E3A9.0043:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 20:16:13 +0000 Arnd Bergmann wrote:

> On Monday 14 December 2009 17:10:05 Randy Dunlap wrote:
> > 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix build failure when CONFIG_BLOCK=n:
> > 
> > fs/compat_ioctl.c:1604: error: 'SG_SET_TRANSFORM' undeclared
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Your patch is obviously correct, but I wonder if we could just drop
> the line completely, given that no driver in the kernel actually
> implements this ioctl command. It was part of the ide-scsi driver
> until 2.6.28, but that driver was removed in 2.6.29.

I checked with Jens, he says yes, drop that case.
Do you want to do that or should I send another patch?

thanks,
---
~Randy
