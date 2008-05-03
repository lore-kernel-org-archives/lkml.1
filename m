Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbYECRsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbYECRsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYECRsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:48:15 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44804 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbYECRsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:48:14 -0400
Date: Sat, 3 May 2008 20:47:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, Avi Kivity <avi@qumranet.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm-devel@lists.sourceforge.net, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: s390 kvm_virtio.c build error
Message-ID: <20080503174716.GM5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c45a6816c19dee67b8f725e6646d428901a6dc24
(virtio: explicit advertisement of driver features)
and commit e976a2b997fc4ad70ccc53acfe62811c4aaec851
(s390: KVM guest: virtio device support, and kvm hypercalls)
don't like each other:

<--  snip  -->

...
  CC      drivers/s390/kvm/kvm_virtio.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/s390/kvm/kvm_virtio.c:224: error: unknown field 'feature' specified in initializer
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/s390/kvm/kvm_virtio.c:224: warning: initialization from incompatible pointer type
make[3]: *** [drivers/s390/kvm/kvm_virtio.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

