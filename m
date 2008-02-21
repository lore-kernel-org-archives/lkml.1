Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbYBUMvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbYBUMvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYBUMuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:50:51 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50754 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbYBUMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:50:50 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWLACA-04-17S-01
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Thu, 21 Feb 2008 13:47:35 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: remove WARN_ON if MTRRs are all blank
Message-ID: <20080221124735.GA20053@amd.com>
References: <1203593558-3391-1-git-send-email-joerg.roedel@amd.com>
 <20080221115452.GB13948@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20080221115452.GB13948@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Feb 2008 12:47:36.0053 (UTC)
 FILETIME=[EF13FA50:01C87487]
X-WSS-ID: 6BA3AC1B0QK12079872-12-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 12:54:52PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> >  	if (!highest_pfn) {
> >  		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
> > -		WARN_ON(1);
> >  		return 0;
> >  	}
> 
> instead of obscuring a possibly useful warning, please instead detect 
> that it's a KVM guest and skip both the warning and the backtrace in 
> that case.

How usefull is the backtrace in that place? I agree that the printk
warning may be usefull, but I don't see why the backtrace from the
WARN_ON is necessary.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


