Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbXIEGCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbXIEGCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 02:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXIEGCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 02:02:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXIEGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 02:02:29 -0400
Message-ID: <46DE45A2.40403@zytor.com>
Date: Wed, 05 Sep 2007 06:58:58 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Robert Richter <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access
 for AMD Barcelona
References: <20070903081736.288288000@amd.com> <20070903081736.588599000@amd.com> <20070903013157.72c94891@laptopd505.fenrus.org> <20070903091718.GB22144@alberich.amd.com> <20070903043319.7573875b@laptopd505.fenrus.org> <20070903154734.GC22086@alberich.amd.com>
In-Reply-To: <20070903154734.GC22086@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> On Mon, Sep 03, 2007 at 04:33:19AM -0700, Arjan van de Ven wrote:
>> On Mon, 3 Sep 2007 11:17:18 +0200
>> "Andreas Herrmann" <andreas.herrmann3@amd.com> wrote:
>> \> 
>>> Do you see any other issues besides the naming of the bit?
>> I wonder if we should key this off a PCI ID of the chipset rather than
>> the cpu id... I mean, how sure are you that all via chipsets connected
>> to the barcelona cpu will deal well?
> 
> In general they should be able to deal with those accesses. They result in
> extended type 0/1 configuration cycles which are defined already in HT I/O Link
> Spec 1.10. So if unexpectedly problems arise then it is time to add a pci-quirk.
> 
> But at the moment there is no need for further discussion on this subject
> because Andi refuses to add support for Barcelona CF8/CFC ECS access.
> 

Well, they don't add any functionality, do they?  As such, I would agree 
with Andi -- we only need one method which can (correctly) access the 
full configuration space, since it'll look the same on the bus anyway.

	-hpa

