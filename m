Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXFVWlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXFVWlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXFVWl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:41:28 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41485 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbXFVWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:41:27 -0400
Date: Fri, 22 Jun 2007 15:43:00 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
In-reply-to: <m1tzszaadm.fsf@ebiederm.dsl.xmission.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <467C5074.6050103@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <200706221219.16243.yinghai.lu@sun.com>
 <20070622193124.GG5051@rhun.smartcity.com>
 <20070622213327.69663288@the-village.bc.nu>
 <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
 <20070622231951.4d516215@the-village.bc.nu>
 <m1tzszaadm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> The original design came from thinking about systems where using the iommu
> was mandatory.  I think we almost always reserve memory below 1G for the kexec
> on panic kernel so it really shouldn't be an issue in that case.  Except
> we need to pass an option to force not using the iommu.  I don't think
> noiommu or swiotlb is going to make any real difference.
> 
> So I'm totally in favor of turning off features if we don't need them and we
> don't take a tremendous performance hit.  (People get grumpy when writing
> all of memory to disk takes completely unreasonable amounts of time).


So you prefer to
add diable_gart in shutdown or suspend func and let kexec to use swiotlb comand line?

YH
