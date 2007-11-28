Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXK1TyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXK1TyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbXK1TyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:54:11 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44168 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753385AbXK1TyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:54:10 -0500
Date: Wed, 28 Nov 2007 11:54:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2 (build failure on arm)
In-Reply-To: <20071128034140.648383f0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711281152220.12651@schroedinger.engr.sgi.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crossbuild on arm with shark_deconfig fails:

  CC [M]  sound/oss/uart401.o
  CC      net/sched/sch_generic.o
  CC      net/core/dst.o
  AS      arch/arm/lib/getuser.o
drivers/ide/arm/ide_arm.c: In function 'ide_arm_init':
drivers/ide/arm/ide_arm.c:42: error: implicit declaration of function 
'ide_device_idx'
make[2]: *** [drivers/ide/arm/ide_arm.o] Error 1
make[1]: *** [drivers/ide] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC      net/core/netevent.o
  CC      net/core/neighbour.o


