Return-Path: <linux-kernel-owner+w=401wt.eu-S1751369Ab0AGROO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab0AGROO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034Ab0AGRON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:14:13 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:56484 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0AGRON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:14:13 -0500
Date: Thu, 7 Jan 2010 09:13:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-06-14-34 uploaded
Message-Id: <20100107091355.c5824da6.randy.dunlap@oracle.com>
In-Reply-To: <12823.1262836907@localhost>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<12343.1262836096@localhost>
	<12823.1262836907@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B461658.007B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 23:01:47 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 06 Jan 2010 22:48:16 EST, Valdis.Kletnieks@vt.edu said:
> 
> > Building with CONFIG_SQUASHFS=m, CONFIG_SQUASHFS_LZMA=y ,
> > and CONFIG_DECOMPRESS_LZMA=n fails:
> 
> > Looks like a missing select/depends for DECOMPRESS_LZMA.  Somebody else can
> > decide which it should be...
> 
> Digging further:
>   
>   x Symbol: DECOMPRESS_LZMA [=n]                                            x  
>   x   Selected by: RD_LZMA [=n] && BLK_DEV_INITRD [=y] || SQUASHFS_LZMA [=y x  
> 
> How the heck did this happen?  Looks like a SELECT *is* there but it's
> not firing??!?

I was able to reproduce this error but I have DECOMPRESS_LZMA=m
instead of =n, so my patch fixes the build error for the =m case.

Please send me your .config file.

---
~Randy
