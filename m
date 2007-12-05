Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXLER2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXLER2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbXLER2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:28:22 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:64047 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbXLER2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:28:21 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Wed, 5 Dec 2007 18:24:53 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] x86_64: some whitespace cleanups in paging code
Message-ID: <20071205172453.GF23093@amd.com>
References: <20071205123033.GA15394@elte.hu>
 <1196865612128-git-send-email-joerg.roedel@amd.com>
 <20071205163724.GA1024@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20071205163724.GA1024@osiris.boeblingen.de.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Dec 2007 17:24:53.0451 (UTC)
 FILETIME=[BF84F1B0:01C83763]
X-WSS-ID: 6B4801620QK3850139-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 05:37:24PM +0100, Heiko Carstens wrote:
> On Wed, Dec 05, 2007 at 03:40:12PM +0100, Joerg Roedel wrote:
> > This patch does some whitespace cleanups in the paging code to fix some
> > checkpatch.pl warnings of my formerly merged cleanup patches.
> >...
> > -			set_pmd(pmd + i,__pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
> > +			set_pmd(pmd+i, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
> 
> Did checkpatch enforce you to remove the spaces around '+'? I thought
> there was/is a common consensus that having spaces around operators is a good
> thing to have. IMHO it's much more readable...
> But anyway, it's not that I want to start a new thread about coding style :)

Checkpatch complained about a missing space after the comma. After I
added one it complained about a line longer than 80 characters. But
luckily it didn't complain about missing spaces around the plus sign ;)

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


