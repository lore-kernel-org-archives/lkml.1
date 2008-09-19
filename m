Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYISWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYISWkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYISWkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:40:37 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:51659 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYISWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:40:36 -0400
X-BigFish: VPS-23(z1039oz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7GSA7-04-5HY-01
Date: Sat, 20 Sep 2008 00:39:51 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080919223951.GC11410@amd.com>
References: <20080919201909.GC10692@amd.com> <20080920065630N.fujita.tomonori@lab.ntt.co.jp> <20080919220946.GB11410@amd.com> <20080920071825A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920071825A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 22:39:51.0547 (UTC) FILETIME=[A10B4CB0:01C91AA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 07:18:11AM +0900, FUJITA Tomonori wrote:
> I don't know it's acceptable if removing the exported interface even
> if the maintainer of it wants to remove it and it's totally
> meaningless.
> 
> 
> > reverting is the wrong way. For AMD IOMMU I want to use the
> > iommu=fullflush way because I want to reuse a parameter thats already
> > there. Thats why I am against your reverting patch.
> > So now I stop repeating my points again and again. EOD.
> 
> I understood you want to use iommu=fullflush but you can't touch the
> generic code without any discussion.
> 
> And even if everyone is happy about the change, it's much better to
> start from scratch rather than try to fix the things done in the wrong
> way.

Just sleep a night about the discussions for this issue and count then
how often you changed your opinions and points. It all started with a
objection from you against 'nofullflush' and ended in that you want to
explain me the develpment process. And then think again if this
unimportant minor change was worth all that ridiculous flaming.

Good night,

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

