Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYF2Pn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYF2Pn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYF2Pnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:43:51 -0400
Received: from mail-va3.bigfish.com ([216.32.180.111]:38930 "EHLO
	mail39-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752195AbYF2Pnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:43:50 -0400
X-Greylist: delayed 1712 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2008 11:43:49 EDT
X-BigFish: VPS-29(zz1432R98dR7efV1805M873fnzz10d3izzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K38D0T-04-68G-01
Date: Sun, 29 Jun 2008 17:14:54 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 02/34] AMD IOMMU: add header file for driver data structures and defines
Message-ID: <20080629151454.GA6692@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-3-git-send-email-joerg.roedel@amd.com> <20080629235410O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080629235410O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Jun 2008 15:14:54.0356 (UTC) FILETIME=[E267BD40:01C8D9FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 12:07:15AM +0900, FUJITA Tomonori wrote:
> On Thu, 26 Jun 2008 21:27:38 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds a header file local to the AMD IOMMU driver with constants and
> > data structures needed in the code.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  include/asm-x86/amd_iommu_types.h |  242 +++++++++++++++++++++++++++++++++++++
> >  1 files changed, 242 insertions(+), 0 deletions(-)
> >  create mode 100644 include/asm-x86/amd_iommu_types.h
> 
> Is necessary to make this file visible to everyone by putting this in
> include/asm?

The alternative was to put this file in arch/x86/kernel/. But I don't
think its the right place for include files. We have include/ for that.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

