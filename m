Return-Path: <linux-kernel-owner+w=401wt.eu-S965616AbXCLNq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616AbXCLNq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965846AbXCLNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:46:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6247 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965627AbXCLNqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:46:55 -0400
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Mon, 12 Mar 2007 14:45:00 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Michael Matz" <matz@suse.de>
cc: "Avi Kivity" <avi@argo.co.il>, discuss@x86-64.org,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH 4/4 TRY#3] optimize and simplify
 get_cycles_sync()
Message-ID: <20070312134500.GG8922@amd.com>
References: <20070309150825.GA13481@amd.com>
 <20070309151511.GE13481@amd.com> <45F1A2FB.7040206@argo.co.il>
 <20070312130245.GE8922@amd.com>
 <Pine.LNX.4.64.0703121427381.25448@wotan.suse.de>
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0703121427381.25448@wotan.suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Mar 2007 13:46:38.0820 (UTC)
 FILETIME=[DBCDD240:01C764AC]
X-WSS-ID: 69EB864B2EG2558503-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 02:29:43PM +0100, Michael Matz wrote:
> Hi Joerg,
> 
> On Mon, 12 Mar 2007, Joerg Roedel wrote:
> 
> > > >+#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
> > > >+	alternative_io_two("cpuid\nrdtsc",
> > > >+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
> > > >+			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
> > > >  
> > > 
> > > why not use the RDTSCP macro here?
> > 
> > Does this macro exist?
> 
> Look carefully at your patch again, or at least the four quoted lines 
> above.  You've added it yourself, in exactly the form you'd need in the 
> alternative_io_two() call :-)

Hmmkay, thanks for opening my eyes :-)
I considered defining this macro while writing this patch, but decided
against this because the X86_FEATURE_RDTSCP on the same line should
documenting the opcode sufficiently. I just forgot to remove that
#define :)

Thanks again,
Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


