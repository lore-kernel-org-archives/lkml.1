Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYHEIGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYHEIGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYHEIGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:06:04 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62407 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755370AbYHEIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:06:00 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K54B3N-04-NEM-01
Date: Tue, 5 Aug 2008 09:49:35 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, rth@twiddle.net, paulus@samba.org,
       benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] sparc64: use iommu_num_pages function in IOMMU code
Message-ID: <20080805074935.GA32012@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com> <1217865890-3593-11-git-send-email-joerg.roedel@amd.com> <20080804.142834.171476315.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080804.142834.171476315.davem@davemloft.net>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Aug 2008 07:49:36.0031 (UTC) FILETIME=[CE53A2F0:01C8F6CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 02:28:34PM -0700, David Miller wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Mon, 4 Aug 2008 18:04:50 +0200
> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> So we rename, then convert everything back.
> 
> This seems like a lot of commit masterbation for what is
> clearly one single change.

I didn't want to change multiple architectures with a single patch so I
splitted it up. The whole renaming in the beginning is to make the patch
series bisectable. But if its no problem to change multiple
architectures with one patch I will those changes in a single patch next
time.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

