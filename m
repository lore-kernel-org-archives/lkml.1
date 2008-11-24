Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYKXFyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYKXFyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKXFye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:54:34 -0500
Received: from mga10.intel.com ([192.55.52.92]:56748 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbYKXFye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:54:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,657,1220252400"; 
   d="scan'208";a="642833166"
Subject: Re: system fails to boot
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jike Song <albcamus@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, tj@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       alex.shi@intel.com
In-Reply-To: <df9815e70811210926x28bfc368xb54298dd6b7ddd83@mail.gmail.com>
References: <1226639781.2866.77.camel@ymzhang>
	 <df9815e70811210926x28bfc368xb54298dd6b7ddd83@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Nov 2008 13:52:01 +0800
Message-Id: <1227505921.2866.148.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-11-22 at 01:26 +0800, Jike Song wrote:
> On Fri, Nov 14, 2008 at 1:16 PM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
> > Jens,
> >
> > We run into system boot failure with kernel 2.6.28-rc. We found it on a couple of
> > machines, including T61 notebook, nehalem machine, and another HPC NX6325 notebook.
> > All the machines use FedoraCore 8 or FedoraCore 9. With kernel prior to 2.6.28-rc,
> > system boot doesn't fail.
> >
> > I debug it and locate the root cause. Pls. see
> > http://bugzilla.kernel.org/show_bug.cgi?id=11899
> > https://bugzilla.redhat.com/show_bug.cgi?id=471517
> >
> 
> Hi Yanmin,
> 
> It seems I still have this problem with -rc6, both root=LABEL and
> root=/dev/sda8.  I have replaced my nash/mkinitrd with patched ones.
Did you recreate the initrd after updating nash/mkinitrd tools?
What's the boot log?

> 
> Maybe a different issue just with the same appearance?
Maybe, but mostly little possibility.

>  Can you boot
> -rc6 smothly on your T61?
Yes, I can boot 2.6.28-rc6 on my T61 and Nehalem machine. Without the patch,
﻿2.6.28-rc6 boot randomly fails on T61.


