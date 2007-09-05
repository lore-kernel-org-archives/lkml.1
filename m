Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXIEKPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXIEKPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbXIEKPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:15:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbXIEKPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:15:40 -0400
Message-ID: <46DE80F0.4000706@zytor.com>
Date: Wed, 05 Sep 2007 11:12:00 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access
 for AMD Barcelona
References: <20070903081736.288288000@amd.com> <20070903081736.588599000@amd.com> <20070903013157.72c94891@laptopd505.fenrus.org> <20070903091718.GB22144@alberich.amd.com> <20070903043319.7573875b@laptopd505.fenrus.org> <20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com> <20070905084427.GE6409@erda.amd.com>
In-Reply-To: <20070905084427.GE6409@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> On 05.09.07 06:58:58, H. Peter Anvin wrote:
> 
>>> But at the moment there is no need for further discussion on this subject
>>> because Andi refuses to add support for Barcelona CF8/CFC ECS access.
>>>
>> Well, they don't add any functionality, do they?  As such, I would agree 
>> with Andi -- we only need one method which can (correctly) access the 
>> full configuration space, since it'll look the same on the bus anyway.
> 
> PCI Devices will not be the same on the bus since PCI read/write
> functions will have different behavior. Without the patches you will
> get an error when accessing ECS with CF8. We need ECS access for
> patches that setups local interrupt vectors. This patches will be
> released soon.

You're missing the point.   How will the PCI bus transactions be 
different when using MMCONFIG versus your extended CF8 version?

> Btw, this patch fixes also config space access with proc/sys fs and
> lspci. I see this as an added functionality as well.

The latter implies the former.  Again, how does this differ from MMCONFIG?

	-hpa

