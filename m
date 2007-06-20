Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXFTSqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXFTSqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbXFTShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:37:06 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:41941 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761023AbXFTShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:37:03 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 20:36:32 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "David Rientjes" <rientjes@google.com>
cc: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] 2.6.22-rc3 perfmon2 : IBS implementation for
 AMD64
Message-ID: <20070620183632.GG24544@erda.amd.com>
References: <20070614215818.509851000@localhost>
 <20070615093331.168842000@localhost>
 <alpine.DEB.0.99.0706151149480.10812@chino.kir.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.0.99.0706151149480.10812@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:36:32.0823 (UTC)
 FILETIME=[ECBF0C70:01C7B369]
X-WSS-ID: 6A67AC3723K947570-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

> Please don't include mixed cases of hex digits.  This entire file has all 
> hex digits in lowercase type, so please conform to that.

I fixed this in the 2nd version of the patch.

> > +#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
> > +#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
> > +#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
> 
> Masks like K8_MTRR_RDMEM_WRMEM_MASK are prone to bugs when the values they 
> are testing change and somebody forgets to update the mask.  Can you make 
> K8_MTRR_RDMEM_WRMEM_MASK defined to be the result of another preprocessor 
> macro expression?  Or, even better, get rid of it completely and modify 
> set_fixed_range()?

This is existing code, won't change that.

Thanks,
-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



