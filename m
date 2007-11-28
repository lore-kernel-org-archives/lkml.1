Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXK1Uam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXK1Uam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbXK1Uae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:30:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:16022 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXK1Uad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=TMDt8CsQ76gQtaFm2puSrA/4hKQGAKWQN3Qh7dicBJaRu6CeEpa7qVKKLGixTdmSvLO82GtP3VAsEFxRTQsLnQqKqo1N94nk/DCx3xiaYK58lA2zALr26vDVoraluwuGKKpCTQ/XQ0wLTneuCNfsRuX2bWyWlJjsDB1Ve+PN5Ok=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.24-rc3-mm2 (build failure on arm)
Date: Wed, 28 Nov 2007 21:33:44 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20071128034140.648383f0.akpm@linux-foundation.org> <Pine.LNX.4.64.0711281152220.12651@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711281152220.12651@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711282133.44643.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007, Christoph Lameter wrote:
> Crossbuild on arm with shark_deconfig fails:
> 
>   CC [M]  sound/oss/uart401.o
>   CC      net/sched/sch_generic.o
>   CC      net/core/dst.o
>   AS      arch/arm/lib/getuser.o
> drivers/ide/arm/ide_arm.c: In function 'ide_arm_init':
> drivers/ide/arm/ide_arm.c:42: error: implicit declaration of function 
> 'ide_device_idx'
> make[2]: *** [drivers/ide/arm/ide_arm.o] Error 1
> make[1]: *** [drivers/ide] Error 2
> make[1]: *** Waiting for unfinished jobs....

Thanks for spotting this!

Andrew: I fixed it in IDE tree (s/ide_device_idx/ide_device_add/),

ide-fix-host-drivers-depending-on-ide_generic-to-probe-for-interfaces-take-2.patch

replaced

ide-fix-host-drivers-depending-on-ide_generic-to-probe-for-interfaces.patch

Bart
