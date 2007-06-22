Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbXFVTs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbXFVTs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFVTsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:48:18 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33632 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXFVTsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:48:17 -0400
Date: Fri, 22 Jun 2007 12:49:35 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
In-reply-to: <20070622193124.GG5051@rhun.smartcity.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <467C27CF.1010205@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <200706221219.16243.yinghai.lu@sun.com>
 <20070622193124.GG5051@rhun.smartcity.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> On Fri, Jun 22, 2007 at 12:19:15PM -0700, Yinghai Lu wrote:
>> [PATCH] x86-64: disable the GART before allocate aperture
>>
>> For K8 system: 4G RAM with memory hole remapping enabled, or more
>> than 4G RAM installed. when mem is allocated for GART, it will do
>> the memset for clear.  and for kexec case, the first kernel already
>> enable that, the memset in second kernel will cause the system
>> restart. So disable that at first before we try to allocate mem for
>> it.
> 
> Why does the memset in the second kernel cause a system restart?
> 
GART is enabled by first kernel, and some driver is using that for DMA.

YH
