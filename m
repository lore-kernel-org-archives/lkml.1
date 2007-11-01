Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbXKASkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbXKASkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXKASj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:39:57 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:6436 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757AbXKASj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:39:56 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Thu, 1 Nov 2007 19:35:37 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [PATCH] x86: show cpuinfo only for online CPUs
Message-ID: <20071101183537.GD5568@alberich.amd.com>
References: <20071101170206.GA7820@alberich.amd.com>
 <472A08F9.8060605@redhat.com> <20071101173543.GB5568@alberich.amd.com>
MIME-Version: 1.0
In-Reply-To: <20071101173543.GB5568@alberich.amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Nov 2007 18:35:37.0573 (UTC)
 FILETIME=[FF2B1150:01C81CB5]
X-WSS-ID: 6B34C3F607S1113022-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 06:35:43PM +0100, Andreas Herrmann3 wrote:
> On Thu, Nov 01, 2007 at 03:12:25PM -0200, Glauber de Oliveira Costa wrote:
> > So it could even work, but as accident. Unless I'm wrong about it, I'd
> > prefer to see an explicit attribution of cpu_index = 0 somewhere for the
> > boot cpu.
> 
> Hmm, will look at this as well.

BTW, isn't it zero initialized anyway?
So, no need to explicitely set cpuinfo->cpu_index=0 for the boot cpu.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



