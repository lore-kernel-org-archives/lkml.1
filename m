Return-Path: <linux-kernel-owner+w=401wt.eu-S1764160AbXJSMrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764160AbXJSMrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXJSMrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:47:03 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:15117 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbXJSMrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:47:01 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Fri, 19 Oct 2007 14:46:44 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: rename iommu.h to gart.h
Message-ID: <20071019124644.GP30139@amd.com>
References: <1192797491473-git-send-email-joerg.roedel@amd.com>
 <20071019124025.GD4361@rhun.haifa.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20071019124025.GD4361@rhun.haifa.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Oct 2007 12:46:45.0630 (UTC)
 FILETIME=[1B6349E0:01C8124E]
X-WSS-ID: 6B0678B21DW2377175-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 02:40:25PM +0200, Muli Ben-Yehuda wrote:
> On Fri, Oct 19, 2007 at 02:38:11PM +0200, Joerg Roedel wrote:
> 
> > This patch renames the include file asm-x86/iommu.h to asm-x86/gart.h to make
> > clear to which IOMMU implementation it belongs. The patch also adds "GART" to
> > the Kconfig line.
> 
> Long overdue IMHO. How about also renaming the config option to
> CONFIG_GART_IOMMU while you're at it?

Right. The exported function and variable names need also a rename in
some cases. I'll prepare a new patch for that to keep the patches small.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


