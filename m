Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYISRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYISRqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYISRqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:46:25 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:6067 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYISRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:46:25 -0400
X-BigFish: VPS-23(z1039oz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7GEOO-04-WPC-01
Date: Fri, 19 Sep 2008 19:46:05 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080919174605.GU24392@amd.com>
References: <20080919164541.GS24392@amd.com> <20080920020917O.fujita.tomonori@lab.ntt.co.jp> <20080919172036.GT24392@amd.com> <20080920023424H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920023424H.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 17:46:05.0874 (UTC) FILETIME=[97530920:01C91A7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 02:34:15AM +0900, FUJITA Tomonori wrote:
> > You keep this option for AMD IOMMU too. If you move it to AMD IOMMU code
> > then you can remove nofullflush there.
> 
> I'm not sure what you mean. You think that we can't change the
> exported option, how can we remove nofullflush option?

You can keep it for GART. But as I already wrote its ok to remove it for
AMD IOMMU.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

