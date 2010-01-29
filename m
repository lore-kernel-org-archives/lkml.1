Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587Ab0A2BTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab0A2BTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 20:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579Ab0A2BTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 20:19:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:7267 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab0A2BTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 20:19:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,363,1262592000"; 
   d="scan'208";a="591365251"
Subject: Re: [BUG] tip tree - No irq handler for vector (irq -1)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B62366E.6040207@cn.fujitsu.com>
References: <4B6143C5.7060602@cn.fujitsu.com>
	 <1264709113.2849.14.camel@sbs-t61.sc.intel.com>
	 <4B62366E.6040207@cn.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 28 Jan 2010 17:18:15 -0800
Message-Id: <1264727895.2849.70.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 17:14 -0800, Li Zefan wrote:
> Suresh Siddha wrote:
> > Zefan,
> > 
> > I have posted a fix for this.
> > 
> > http://marc.info/?l=linux-kernel&m=126420641021426&w=2
> > 
> > Can you please check if this indeed fixes your issue?
> > 
> 
> Yes, it works. Thanks!
> 
> But I still saw this:
> 
> do_IRQ: 1.48 No irq handler for vector (irq -1)

hmm.. Can you send me the complete kernel log after the above fix is
applied including the output of cat /proc/cpuinfo aswell as
cat /proc/interrupts?

thanks,
suresh

