Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbXJWB61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbXJWB61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXJWB6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:58:20 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:32189 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbXJWB6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:58:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Question about free/used memory on Linux
Date: Mon, 22 Oct 2007 18:58:17 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B848B@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <471C75E7.2070400@draigBrady.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about free/used memory on Linux
Thread-Index: AcgUkyzCfshk5SOkQG683qpnaO0lvQAhJKPg
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471C75E7.2070400@draigBrady.com>
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: =?iso-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Oct 2007 01:58:18.0314 (UTC) FILETIME=[2E7902A0:01C81518]
Authentication-Results: sj-dkim-1; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks all for the answers.

I could load by specifying lower amount of memory but on the newer
platform(does not exist), some of the existing components will
not exist while some newer ones will be added. So, it won't be
entirely accurate but I could still get some idea by trying
it out.

Thanks,
Ravi 

-----Original Message-----
From: Pádraig Brady [mailto:P@draigBrady.com] 
Sent: Monday, October 22, 2007 3:05 AM
To: Ravinandan Arakali (rarakali)
Cc: Linux Kernel
Subject: Re: Question about free/used memory on Linux

Ravinandan Arakali (rarakali) wrote:
> Hi kernel gurus,
> I am trying to find out the memory that's used on my linux box.
> I find that there are quite a few confusing metrics. How do I find out 
> the "true" used memory ?
> 
> 1. For eg. "free -m" shows free memory (excluding buffers/caches) as 
> 308 MB while I can see(from "df" output) that the the tmpfs partitions 
> take up about 400 MB. So, does "free -m" not consider the tmpfs 
> partitions ?
> 
> 2. I try to add up RSS field of all processes reported by "ps aux" 
> command. But is it true that this would be misleading in that, shared 
> memory used by, say 2 processes would show up twice here although 
> there's only one copy in memory. Also does this consider the fact that 
> there's only one copy of shared libraries ?

Have a look at this script so show RAM used by programs:
http://www.pixelbeat.org/scripts/ps_mem.py

Note to display totals you will need this patch applied:
http://lkml.org/lkml/2007/8/13/1224

Pádraig.
