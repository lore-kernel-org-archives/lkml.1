Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXKFScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXKFScT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbXKFScM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:32:12 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:28598 "EHLO
	mail160-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXKFScL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:32:11 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Tue, 6 Nov 2007 19:31:53 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Zou Nan hai" <nanhai.zou@intel.com>
cc: "LKML" <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>
Subject: Re: [Patch1/2] fix wrong proc cpuinfo on x64
Message-ID: <20071106183153.GC15369@alberich.amd.com>
References: <1194333939.3046.36.camel@linux-znh>
MIME-Version: 1.0
In-Reply-To: <1194333939.3046.36.camel@linux-znh>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Nov 2007 18:31:48.0521 (UTC)
 FILETIME=[4AB54190:01C820A3]
X-WSS-ID: 6B2E6C9C07S1610171-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 03:25:39PM +0800, Zou Nan hai wrote:
> 
> in 2.6.24-rc1 kernel, 
> The /proc/cpuinfo display is wrong.
> 
> One issue is every processor id appears to be 0.
> 
> That is because smp_store_cpu_info will set cpuinfo_x86->cpu_index
> to cpu id then call identify_cpu
> identify_cpu will call early_identify_cpu which set c->cpu_index back to
> 0.

This issue should already be fixed with this patch

http://marc.info/?l=linux-kernel&m=119392088227245


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



