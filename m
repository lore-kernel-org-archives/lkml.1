Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYKXG7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYKXG7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYKXG7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:59:43 -0500
Received: from mga12.intel.com ([143.182.124.36]:22961 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751370AbYKXG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:59:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,657,1220252400"; 
   d="scan'208";a="81519451"
Subject: Re: system fails to boot
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jike Song <albcamus@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, tj@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       alex.shi@intel.com
In-Reply-To: <df9815e70811232240y7480edao14d653c24cf2e01@mail.gmail.com>
References: <1226639781.2866.77.camel@ymzhang>
	 <df9815e70811210926x28bfc368xb54298dd6b7ddd83@mail.gmail.com>
	 <1227505921.2866.148.camel@ymzhang>
	 <df9815e70811232240y7480edao14d653c24cf2e01@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 14:57:07 +0800
Message-Id: <1227509827.2866.156.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-11-24 at 14:40 +0800, Jike Song wrote:
> On Mon, Nov 24, 2008 at 1:52 PM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
> >
> > On Sat, 2008-11-22 at 01:26 +0800, Jike Song wrote:
> >> On Fri, Nov 14, 2008 at 1:16 PM, Zhang, Yanmin
> >> <yanmin_zhang@linux.intel.com> wrote:
> >> > Jens,
> >> >
> >> > We run into system boot failure with kernel 2.6.28-rc. We found it on a couple of
> >> > machines, including T61 notebook, nehalem machine, and another HPC NX6325 notebook.
> >> > All the machines use FedoraCore 8 or FedoraCore 9. With kernel prior to 2.6.28-rc,
> >> > system boot doesn't fail.
> >> >
> >> > I debug it and locate the root cause. Pls. see
> >> > http://bugzilla.kernel.org/show_bug.cgi?id=11899
> >> > https://bugzilla.redhat.com/show_bug.cgi?id=471517
> >> >
> >>
> >> Hi Yanmin,
> >>
> >> It seems I still have this problem with -rc6, both root=LABEL and
> >> root=/dev/sda8.  I have replaced my nash/mkinitrd with patched ones.
> > Did you recreate the initrd after updating nash/mkinitrd tools?
> 
> Yes, I run "make install" at first, and found the failure of boot;
> Then I recreated initrd manually with mkinitrd/nash (patched by you),
> and booted -rc6 again - failed again.
Would you like to write down the detailed steps?

> 
> > What's the boot log?
> Sorry I don't have the laptop with me now, will post it this
> evening(Ah, only possible if I can get netconsole work).   Anyway,
> your patches did work for me with -rc4, so I think I'll bisect it.
That's good if the boot always fails. But when root=/dev/sdaXXX, system
boot fails randomly.


