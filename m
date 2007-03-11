Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXCKMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXCKMlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933336AbXCKMlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:41:17 -0400
Received: from atl.uu.jhcloos.net ([207.210.96.115]:49876 "EHLO
	atl.uu.jhcloos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320AbXCKMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:41:16 -0400
From: James Cloos <cloos@jhcloos.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
In-Reply-To: <200703111016.01154.kernel@kolivas.org> (Con Kolivas's message of
	"Sun\, 11 Mar 2007 10\:16\:00 +1100")
References: <20070309053931.GA10459@waste.org>
	<200703100807.43582.kernel@kolivas.org>
	<m3ejnxqbfl.fsf@lugabout.jhcloos.org>
	<200703111016.01154.kernel@kolivas.org>
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2007 James Cloos
X-Hashcash: 1:23:070311:kernel@kolivas.org::7sUyADykG5H14B4S:00000000000000000000000000000000000000000005atg
X-Hashcash: 1:23:070311:mpm@selenic.com::HThhnDjMDY2yFLez:00Ckj0
X-Hashcash: 1:23:070311:linux-kernel@vger.kernel.org::YSTWPN8OYxqig4S/:000000000000000000000000000000000Bcl2
X-Hashcash: 1:23:070311:akpm@linux-foundation.org::LvJ8iJlFnKRGiExG:000000000000000000000000000000000000Ysmw
Date: Sun, 11 Mar 2007 08:38:41 -0400
Message-ID: <m38xe4vtsn.fsf@lugabout.jhcloos.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

|> See:
|> http://webcvs.freedesktop.org/mesa/Mesa/src/mesa/drivers/dri/r200/r200_ioctl.c?revision=1.37&view=markup

OK.

Mesa is in git, now, but that still applies.  The gitweb url is:

http://gitweb.freedesktop.org/?p=mesa/mesa.git

and for the version of the above file in the master branch:

http://gitweb.freedesktop.org/?p=mesa/mesa.git;a=blob;f=src/mesa/drivers/dri/r200/r200_ioctl.c

The recursive grep(1) on mesa shows:

,----[grep -r sched_yield mesa]
| mesa/mesa/src/mesa/drivers/dri/r300/radeon_ioctl.c:	    sched_yield();
| mesa/mesa/src/mesa/drivers/dri/i915tex/intel_batchpool.c:      sched_yield();
| mesa/mesa/src/mesa/drivers/dri/i915tex/intel_batchbuffer.c:         sched_yield();
| mesa/mesa/src/mesa/drivers/dri/common/vblank.h:#include <sched.h>   /* for sched_yield() */
| mesa/mesa/src/mesa/drivers/dri/common/vblank.h:#include <sched.h>   /* for sched_yield() */
| mesa/mesa/src/mesa/drivers/dri/common/vblank.h:      sched_yield();							\
| mesa/mesa/src/mesa/drivers/dri/unichrome/via_ioctl.c:      sched_yield();
| mesa/mesa/src/mesa/drivers/dri/i915/intel_ioctl.c:	 sched_yield();
| mesa/mesa/src/mesa/drivers/dri/r200/r200_ioctl.c:       sched_yield();
`----

Thanks for the heads up.  I must've grep(1)ed the xorg subdir rather
than the parent dir, and so missed mesa.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
