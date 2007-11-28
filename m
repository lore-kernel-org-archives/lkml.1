Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXK1Tw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXK1Tw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbXK1TwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:52:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44032 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751794AbXK1TwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:52:20 -0500
Date: Wed, 28 Nov 2007 11:52:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2 (build failure on s390) 
In-Reply-To: <20071128034140.648383f0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711281151130.12651@schroedinger.engr.sgi.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cross build with s390 default configuration (make defconfig) fails

  CC      arch/s390/kernel/irq.o
  CC      arch/s390/kernel/ipl.o
  CC      arch/s390/kernel/dis.o
  CC      fs/open.o
  LD      arch/s390/hypfs/s390_hypfs.o
arch/s390/kernel/ipl.c: In function 'ipl_register_fcp_files':
arch/s390/kernel/ipl.c:415: error: 'ipl_subsys' undeclared (first use in 
this function)
arch/s390/kernel/ipl.c:415: error: (Each undeclared identifier is reported 
only once
arch/s390/kernel/ipl.c:415: error: for each function it appears in.)
arch/s390/kernel/ipl.c: In function 'ipl_init':
arch/s390/kernel/ipl.c:449: error: implicit declaration of function 
'firmware_register'
arch/s390/kernel/ipl.c:449: error: 'ipl_subsys' undeclared (first use in 
this func

