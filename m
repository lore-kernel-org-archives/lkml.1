Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbXCJRhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbXCJRhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 12:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXCJRhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 12:37:15 -0500
Received: from atl.uu.jhcloos.net ([207.210.96.115]:60181 "EHLO
	atl.uu.jhcloos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbXCJRhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 12:37:13 -0500
X-Greylist: delayed 1972 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 12:37:13 EST
From: James Cloos <cloos@jhcloos.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
In-Reply-To: <200703100807.43582.kernel@kolivas.org> (Con Kolivas's message of
	"Sat\, 10 Mar 2007 08\:07\:43 +1100")
References: <20070309053931.GA10459@waste.org>
	<200703091939.05535.kernel@kolivas.org>
	<20070309204623.GE10394@waste.org>
	<200703100807.43582.kernel@kolivas.org>
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2006 James Cloos
X-Hashcash: 1:23:070310:akpm@linux-foundation.org::s5/5Vq6BVw4Pg7sN:0000000000000000000000000000000000006e/x
X-Hashcash: 1:23:070310:linux-kernel@vger.kernel.org::RVhJmiKoVPHV4i0Q:000000000000000000000000000000000MnTH
X-Hashcash: 1:23:070310:mpm@selenic.com::+CGZdIdnsYHQarHZ:005qxw
X-Hashcash: 1:23:070310:kernel@kolivas.org::zBCUzOjgn8tRCpxL:0000000000000000000000000000000000000000000EVak
Date: Sat, 10 Mar 2007 12:01:59 -0500
Message-ID: <m3ejnxqbfl.fsf@lugabout.jhcloos.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Con" == Con Kolivas <kernel@kolivas.org> writes:

Con> It's sad that sched_yield is still in our graphics card drivers ...

I just did a recursive grep(1) on my mirror of the freedesktop git
repos for sched_yield.  This only checked the master branches as I
did not bother to script up something to clone each, check out all
branches in turn, and grep(1) each possibility.

The output is just:

:; grep -r sched_yield FDO/xorg
FDO/xorg/xserver/hw/kdrive/via/viadraw.c:		sched_yield();
FDO/xorg/driver/xf86-video-glint/src/pm2_video.c:    if (sync) /* sched_yield? */

Is there something else I should grep(1) for?  If not, it looks as
if sched_yield(2) has been evicted from the drivers.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
