Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXISQFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXISQFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbXISQFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:05:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXISQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:05:34 -0400
Message-ID: <46F148C2.7020805@zytor.com>
Date: Wed, 19 Sep 2007 09:05:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2 2/2] i386/x86_64 boot: document for 32 bit boot
 protocol
References: <1190171428.12429.63.camel@caritas-dev.intel.com> <20070919103432.49ab7dc0@the-village.bc.nu>
In-Reply-To: <20070919103432.49ab7dc0@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 19 Sep 2007 11:10:28 +0800
> "Huang, Ying" <ying.huang@intel.com> wrote:
> 
>> This patch defines a 32-bit boot protocol and adds corresponding
>> document. It is based on the proposal of Peter Anvin.
>>
>>
>> Known issues:
>>
>> - The hd0_info and hd1_info are deleted from the zero page. Additional
>>   work should be done for this? Or this is unnecessary (because no new
>>   fields will be added to zero page)?
> 
> They aren't actually that useful as for pretty much any 386 or later PC
> we can recover the disk geometry via the BIOS tables, or via EDD. Right
> now we don't save some neccessary fields if using EDD 1.1 but they could
> be saved into the same place EDD 3.0 puts them.
> 

Yeah, I just don't want to remove them from the structure to keep the
locations from getting recycled for a while.

	-hpa
