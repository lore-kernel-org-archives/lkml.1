Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYF0KRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYF0KRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYF0KQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:16:40 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26823 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYF0KQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:16:39 -0400
X-BigFish: VPS-47(zz146fK1432R14e0Q98dR7efV1805Mzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K349V6-03-BC1-01
Date: Fri, 27 Jun 2008 12:15:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 00/34] AMD IOMMU driver
Message-ID: <20080627101519.GM1303@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <20080627081807.GA6562@elte.hu> <20080627100751.GA27822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080627100751.GA27822@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 27 Jun 2008 10:15:19.0166 (UTC) FILETIME=[B387E9E0:01C8D83E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Jun 27, 2008 at 12:07:51PM +0200, Ingo Molnar wrote:
> 
> -tip testing found a build failure with:
> 
> arch/x86/kernel/amd_iommu_init.c:247: warning: 'struct acpi_table_header' declared inside parameter list
> arch/x86/kernel/amd_iommu_init.c:247: warning: its scope is only this definition or declaration, which is probably not what you want
> arch/x86/kernel/amd_iommu_init.c: In function 'find_last_devid_acpi':
> arch/x86/kernel/amd_iommu_init.c:257: error: dereferencing pointer to incomplete type
> 
>   http://redhat.com/~mingo/misc/config-Fri_Jun_27_10_29_06_CEST_2008.bad
> 
> this is due to !CONFIG_ACPI.
> 
> since AMD IOMMU discovery depends on ACPI anyway, i've fixed this in the 
> Kconfig space. (Eventually, if you want to make it directly discoverable 
> via the PCI space in the future, you might want to fix this dependency.)
> 
> i've pushed out the fix below into -tip.

Thank you for your testing and the fixes. I will test the result from
your tree.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

