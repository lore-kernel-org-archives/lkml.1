Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYHFOZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYHFOZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbYHFOZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:25:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755411AbYHFOZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:25:14 -0400
Message-ID: <4899B418.9050509@linux-foundation.org>
Date: Wed, 06 Aug 2008 09:24:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com>	 <489738CF.7090401@linux-foundation.org>	 <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48986AC6.5030406@linux-foundation.org> <2f11576a0808060536o53cabb93m6387d35e3e5791be@mail.gmail.com>
In-Reply-To: <2f11576a0808060536o53cabb93m6387d35e3e5791be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>>> Can you quantify the difference?
>>> machine spec:
>>> CPU: IA64 x 8
>>> MEM: 8G (4G x2node)
>> 16k or 64k page size?
> 
> 64k.
> 
> 
>>> So, about 2.5G - 3G difference in 8G mem.
>> Well not sure if that tells us much. Please show us the output of
>> /proc/meminfo after each run. The slab counters indicate how much memory is
>> used by the slabs.
>>
>> It would also be interesting to see the output of the slabinfo command after
>> the slub run?
> 
> ok.
> but i can't do that in this week.
> so, I'll do it in next week.
> 
> honestly, I don't know how to use slabinfo command :-)

Its in linux/Documentation/vm/slabinfo.c

Do

	gcc -o slabinfo Documentation/vm/slabinfo.c

	./slabinfo

(./slabinfo -h if you are curious and want to use more advanced options)

