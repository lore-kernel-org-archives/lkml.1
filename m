Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbYJaPPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbYJaPPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJaPOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:14:53 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:52467 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYJaPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:14:52 -0400
X-BigFish: VPS-35(z5edJ34a4jz62a3L1432R98dR936eQ1805Mzzzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K9LZO6-01-JS5-01
Date: Fri, 31 Oct 2008 16:14:13 +0100
From: Robert Richter <robert.richter@amd.com>
To: Carl Love <cel@us.ibm.com>
CC: michael@ellerman.id.au, Hannsj_uhl <Hannsj_uhl@de.ibm.com>,
       acjohnso <acjohnso@us.ibm.com>, oprofile-list@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org, cel@linux.vnet.ibm.com, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [UPDATED PATCH VER2] Cell OProfile: Incorrect local array size
	in activate spu profiling function
Message-ID: <20081031151413.GE9785@erda.amd.com>
References: <1224874049.20229.5.camel@carll-linux-desktop> <1224909595.16090.5.camel@localhost> <1225207079.20229.32.camel@carll-linux-desktop> <1225241514.7799.2.camel@localhost> <1225292805.20229.52.camel@carll-linux-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1225292805.20229.52.camel@carll-linux-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Oct 2008 15:14:35.0094 (UTC) FILETIME=[62259760:01C93B6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.10.08 08:06:45, Carl Love wrote:
> Updated the patch to address comments by Michael Ellerman.  
> Specifically, changed upper limit in for loop to 
> ARRAY_SIZE() macro and added a check to make sure the 
> number of events specified by the user, which is used as
> the max for indexing various arrays, is no bigger then the
> declared size of the arrays.
> 
> The size of the pm_signal_local array should be equal to the
> number of SPUs being configured in the array.  Currently, the
> array is of size 4 (NR_PHYS_CTRS) but being indexed by a for 
> loop from 0 to 7 (NUM_SPUS_PER_NODE).  
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>

I applied your patch to oprofile/oprofile-for-tip. Thanks Carl.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

