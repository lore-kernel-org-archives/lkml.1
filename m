Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbXFMR7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbXFMR7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbXFMR7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:59:23 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:60924 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009AbXFMR7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:59:23 -0400
Date: Wed, 13 Jun 2007 20:59:21 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
In-Reply-To: <20070613161513.GE3875@redhat.com>
Message-ID: <Pine.SOC.4.64.0706132059100.9655@math>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com>
 <20070613161513.GE3875@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, we have this check in find_gmch ..
> 
>         if (gmch_device && PCI_FUNC(gmch_device->devfn) != 0) {
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Which isn't going to work, as Meelis has a gmch on device0, slot0, devfn1.
> Meelis, does it start working again if you change that to just
> 
> 	if (gmch_Device) {
> 
> ?

Still the same.

-- 
Meelis Roos (mroos@linux.ee)
