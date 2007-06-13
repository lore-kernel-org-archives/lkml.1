Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXFMSTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXFMSTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbXFMSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:19:38 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:54571 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724AbXFMSTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:19:38 -0400
Date: Wed, 13 Jun 2007 21:19:35 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Wang Zhenyu <zhen78@gmail.com>
cc: Dave Jones <davej@redhat.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
In-Reply-To: <20070613180039.GA4508@localhost.localdomain>
Message-ID: <Pine.SOC.4.64.0706132118480.9655@math>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com>
 <20070613161513.GE3875@redhat.com> <20070613180039.GA4508@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No, the problem for i815 is that it has a config with no integrated gfx.
> Sorry I missed it. Meelis, pls test with this patch, which adds a table 
> item for this, and fixes wrong driver order within origin i815 driver with IGD.

Thanks, this fixes it. dmesg is fine and X log shows it's using AGP 
again.

-- 
Meelis Roos (mroos@linux.ee)
