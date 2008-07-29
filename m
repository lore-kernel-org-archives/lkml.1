Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbYG2Rzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbYG2Rzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYG2RzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:55:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:37933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbYG2RzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SYkj9JUCUDBSmkAvNylPKVGfisaAhtM0qr/eexDVJnJwe2UPq6fYSazVOJUmiyfYSZ
         oKhpVsd53WJ31ZRcmRHl8SqohHf289PMXSPzUAYIxdteGPerxCuREO+ZoNonfBVcy4uQ
         qKfFwkP5pV02yPyYdw+oRrgU7dcxK6XdpWzB0=
Date: Tue, 29 Jul 2008 21:54:18 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: sparc64 build failure at iommu.c
Message-ID: <20080729175418.GA32295@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It is double declaration.
Kernel version is 2.6.27-rc1

In file included from arch/sparc64/kernel/iommu.c:21:
arch/sparc64/kernel/iommu_common.h:40: error: static declaration of
'iommu_num_pages' follows non-static declaration
include/linux/iommu-helper.h:11: error: previous declaration of
'iommu_num_pages' was here
