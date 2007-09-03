Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXICPsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXICPsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 11:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXICPsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 11:48:11 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:31956 "EHLO
	outbound6-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbXICPsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 11:48:10 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 3 Sep 2007 17:47:34 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Arjan van de Ven" <arjan@infradead.org>
cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070903154734.GC22086@alberich.amd.com>
References: <20070903081736.288288000@amd.com>
 <20070903081736.588599000@amd.com>
 <20070903013157.72c94891@laptopd505.fenrus.org>
 <20070903091718.GB22144@alberich.amd.com>
 <20070903043319.7573875b@laptopd505.fenrus.org>
MIME-Version: 1.0
In-Reply-To: <20070903043319.7573875b@laptopd505.fenrus.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Sep 2007 15:47:33.0107 (UTC)
 FILETIME=[BDFC6C30:01C7EE41]
X-WSS-ID: 6AC2F3251A46481492-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 04:33:19AM -0700, Arjan van de Ven wrote:
> On Mon, 3 Sep 2007 11:17:18 +0200
> "Andreas Herrmann" <andreas.herrmann3@amd.com> wrote:
> \> 
> > Do you see any other issues besides the naming of the bit?
> 
> I wonder if we should key this off a PCI ID of the chipset rather than
> the cpu id... I mean, how sure are you that all via chipsets connected
> to the barcelona cpu will deal well?

In general they should be able to deal with those accesses. They result in
extended type 0/1 configuration cycles which are defined already in HT I/O Link
Spec 1.10. So if unexpectedly problems arise then it is time to add a pci-quirk.

But at the moment there is no need for further discussion on this subject
because Andi refuses to add support for Barcelona CF8/CFC ECS access.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



