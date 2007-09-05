Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXIEIpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXIEIpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 04:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbXIEIp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 04:45:28 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:12439 "EHLO
	outbound9-blu-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755971AbXIEIp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 04:45:26 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 5 Sep 2007 10:44:27 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070905084427.GE6409@erda.amd.com>
References: <20070903081736.288288000@amd.com>
 <20070903081736.588599000@amd.com>
 <20070903013157.72c94891@laptopd505.fenrus.org>
 <20070903091718.GB22144@alberich.amd.com>
 <20070903043319.7573875b@laptopd505.fenrus.org>
 <20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46DE45A2.40403@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 05 Sep 2007 08:44:27.0529 (UTC)
 FILETIME=[F7D41F90:01C7EF98]
X-WSS-ID: 6AC0B3F11A46651931-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.07 06:58:58, H. Peter Anvin wrote:

> >But at the moment there is no need for further discussion on this subject
> >because Andi refuses to add support for Barcelona CF8/CFC ECS access.
> >
> 
> Well, they don't add any functionality, do they?  As such, I would agree 
> with Andi -- we only need one method which can (correctly) access the 
> full configuration space, since it'll look the same on the bus anyway.

PCI Devices will not be the same on the bus since PCI read/write
functions will have different behavior. Without the patches you will
get an error when accessing ECS with CF8. We need ECS access for
patches that setups local interrupt vectors. This patches will be
released soon.

Btw, this patch fixes also config space access with proc/sys fs and
lspci. I see this as an added functionality as well.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


