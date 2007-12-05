Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbXLELmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbXLELmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXLELmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:42:43 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:26114 "EHLO
	mail4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXLELmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:42:42 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Wed, 5 Dec 2007 12:42:25 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86_64: define all _PAGE_* in terms of
 _PAGE_BIT_*
Message-ID: <20071205114225.GC23093@amd.com>
References: <11966016811565-git-send-email-joerg.roedel@amd.com>
 <11966016814058-git-send-email-joerg.roedel@amd.com>
 <20071204123809.GD27286@elte.hu> <20071204150652.GJ6945@amd.com>
 <20071204210751.GH32018@elte.hu> <20071205105236.GB23093@amd.com>
 <20071205112758.GA6143@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20071205112758.GA6143@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Dec 2007 11:42:25.0326 (UTC)
 FILETIME=[E7E1E4E0:01C83733]
X-WSS-ID: 6B48512E2IW3788538-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 12:27:58PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > > > > please run patches through scripts/checkpatch.pl, it gives:
> > > > > 
> > > > >   total: 10 errors, 0 warnings, 42 lines checked
> > > > > 
> > > > > (please send a followup cleanup patch - i picked up your series and this 
> > > > > is a minor cleanliness issue)
> > > > 
> > > > Sorry, forgot to check the patches before submission. Will cleanup and 
> > > > resubmit soon.
> > > 
> > > please if possible send a delta against x86.git, not a replacement 
> > > patch. It's easier for the patchflow.
> > 
> > Not sure I understand you right here. Do you mean a patch on top of my 
> > previous patches?
> 
> yeah - that's easier to pick up for me (because i've already got your 
> series applied), and it's also easier for you as well. It also makes 
> sense to generally split style fixes from substantial patches. (in the 
> cases where there are pre-existing style problems in the code)

Ok, thanks. Will prepare a patch on top of my first patch series.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


