Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXKFSiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXKFSiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXKFSh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:37:59 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:40269 "EHLO
	mail114-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbXKFSh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:37:58 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Tue, 6 Nov 2007 19:37:10 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Zou Nan hai" <nanhai.zou@intel.com>
cc: "LKML" <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>
Subject: Re: [Patch2/2] fix wrong proc cpuinfo on x64
Message-ID: <20071106183710.GD15369@alberich.amd.com>
References: <1194333940.3046.38.camel@linux-znh>
MIME-Version: 1.0
In-Reply-To: <1194333940.3046.38.camel@linux-znh>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Nov 2007 18:37:04.0876 (UTC)
 FILETIME=[074532C0:01C820A4]
X-WSS-ID: 6B2E6BFD07S1611020-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 04:28:20PM +0800, Zou Nan hai wrote:
> in 2.6.24-rc1 kernel, 
> The /proc/cpuinfo display is wrong.
> 
> Another issue is that it will display bogus cpus with wrong information
> if the kernel is compiled with a big CONFIG_NR_CPU.
> 
> That is because before a cpu in cpu_present_map is up, c->cpu_index of
> that cpu is 0.
> thus the cpu_online(c->cpu_index) check in show_cpuinfo is invalid.

This issue should already be fixed with that patch

http://marc.info/?l=linux-kernel&m=119394201230954

> This patch will let cpuinfo_op use cpu_online_map instead of
> cpu_present_map to iterate cpus.

BTW, the problem affects i386 as well.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



