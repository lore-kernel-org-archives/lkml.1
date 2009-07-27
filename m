Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZG0JJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZG0JJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZG0JJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:09:35 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44542 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbZG0JJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:09:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: drbd tree build failure
Date: Mon, 27 Jul 2009 11:09:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090727173754.6a04e781.sfr@canb.auug.org.au>
In-Reply-To: <20090727173754.6a04e781.sfr@canb.auug.org.au>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907271109.33271.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009 09:37:54 Stephen Rothwell wrote:
> Hi Philipp,
>
> Today's linux-next build (powerpc allyesconfig) failed like this:
>
> drivers/block/drbd/drbd_trace.o: In function `.roles_to_name':
> (.text+0x64): multiple definition of `.roles_to_name'
> drivers/block/drbd/drbd.o:(.text+0x28eb8): first defined here
> drivers/block/drbd/drbd_trace.o: In function `disks_to_name':
> (.opd+0x30): multiple definition of `disks_to_name'
> drivers/block/drbd/drbd.o:(.opd+0x1b78): first defined here
> drivers/block/drbd/drbd_trace.o: In function `roles_to_name':
> (.opd+0x18): multiple definition of `roles_to_name'
> drivers/block/drbd/drbd.o:(.opd+0x1b60): first defined here
> drivers/block/drbd/drbd_trace.o: In function `.conns_to_name':
> (.text+0x0): multiple definition of `.conns_to_name'
> drivers/block/drbd/drbd.o:(.text+0x28e54): first defined here
> drivers/block/drbd/drbd_trace.o: In function `set_st_err_name':
> (.opd+0x48): multiple definition of `set_st_err_name'
> drivers/block/drbd/drbd.o:(.opd+0x1b90): first defined here
> drivers/block/drbd/drbd_trace.o: In function `.disks_to_name':
> (.text+0xcc): multiple definition of `.disks_to_name'
> drivers/block/drbd/drbd.o:(.text+0x28f20): first defined here
> drivers/block/drbd/drbd_trace.o: In function `conns_to_name':
> (.opd+0x0): multiple definition of `conns_to_name'
> drivers/block/drbd/drbd.o:(.opd+0x1b48): first defined here
> drivers/block/drbd/drbd_trace.o: In function `.set_st_err_name':
> (.text+0x134): multiple definition of `.set_st_err_name'
> drivers/block/drbd/drbd.o:(.text+0x28f88): first defined here
>
> I applied the following patch to mark DRBD_TRACE broken for now.

I have fixed that issue. With the next pull, drbd_tracing should
compile on PPC. 

BTW, we are working on making our stuff compatible with Rusty's
cpu set changes. I expect that this will be finished soon...

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

