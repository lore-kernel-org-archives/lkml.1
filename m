Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbXLEKxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbXLEKxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXLEKwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:52:54 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:59418 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbXLEKwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:52:53 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Wed, 5 Dec 2007 11:52:36 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86_64: define all _PAGE_* in terms of
 _PAGE_BIT_*
Message-ID: <20071205105236.GB23093@amd.com>
References: <11966016811565-git-send-email-joerg.roedel@amd.com>
 <11966016814058-git-send-email-joerg.roedel@amd.com>
 <20071204123809.GD27286@elte.hu> <20071204150652.GJ6945@amd.com>
 <20071204210751.GH32018@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20071204210751.GH32018@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Dec 2007 10:52:37.0151 (UTC)
 FILETIME=[F2CA92F0:01C8372C]
X-WSS-ID: 6B485D720QK3808864-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 10:07:54PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Tue, Dec 04, 2007 at 01:38:09PM +0100, Ingo Molnar wrote:
> > > 
> > > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > +#define _PAGE_PRESENT	(_AC(1,UL)<<_PAGE_BIT_PRESENT)
> > > 
> > > please run patches through scripts/checkpatch.pl, it gives:
> > > 
> > >   total: 10 errors, 0 warnings, 42 lines checked
> > > 
> > > (please send a followup cleanup patch - i picked up your series and this 
> > > is a minor cleanliness issue)
> > 
> > Sorry, forgot to check the patches before submission. Will cleanup and 
> > resubmit soon.
> 
> please if possible send a delta against x86.git, not a replacement 
> patch. It's easier for the patchflow.

Not sure I understand you right here. Do you mean a patch on top of my
previous patches?

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


