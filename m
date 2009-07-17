Return-Path: <linux-kernel-owner+w=401wt.eu-S934613AbZGQNeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbZGQNeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934558AbZGQNeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:34:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:60101 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbZGQNeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:34:15 -0400
Message-ID: <4A607D9D.6090301@gmail.com>
Date: Fri, 17 Jul 2009 16:33:17 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: dedekind@infradead.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clean up some extra unused arguments in fs/ubifs/
References: <20090717062101.11440.49299.sendpatchset@subratamodak.linux.ibm.com>	 <1247815718.11353.177.camel@localhost.localdomain> <1247837392.5690.3.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1247837392.5690.3.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Jul 2009 13:33:22.0278 (UTC) FILETIME=[2774A860:01CA06E3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> On Fri, 2009-07-17 at 10:28 +0300, Artem Bityutskiy wrote:
>> On Fri, 2009-07-17 at 11:51 +0530, Subrata Modak wrote:
>>> Hi,
>>>
>>> "const struct ubifs_info *c" exists as an extra argument for major
>>> function definitions under the "fs/ubifs/*" code. The reason why
>>> this extra argument exists is based on assumtion that there
>>> will be several key schemes. It is possible to add more than one,
>>> but we use only one. When there is practically no usage of them
>>> presently, they can be removed, and if needed can be added later.
>>>
>>> The following patch does that by removing:
>>> 1) "const struct ubifs_info *c" where it is not used/necessary,
>>> 2) remove xent_key_init_hash() function, as it is also not used,
>>> 3) remove data_key_init_flash() function, as it is also not used anywhere,
>> Fine with 2 and 3. Not fine with 1, unless it makes the code smaller
>> or more optimal.
> 
> Hmmm. I see. But, it took 95% of my effort.

But yesterday I said that I would not like to remove that argument
unless it makes the code larger. You answered you would check this.
And then you came up with this patches.

> Ok then, do you want me to
> send a separate patch for 2) & 3), or, you will automatically isolate
> them from the sent one.

I can isolate them myself, thanks for the patch.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
