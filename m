Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbXBMSM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbXBMSM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXBMSM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:12:57 -0500
Received: from dvhart.com ([64.146.134.43]:56404 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXBMSM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:12:56 -0500
Message-ID: <45D1FF43.9050800@mbligh.org>
Date: Tue, 13 Feb 2007 10:11:15 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com> <45D1F0B1.3020508@mbligh.org> <200702131845.05913.ak@suse.de>
In-Reply-To: <200702131845.05913.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Your description of the node is correct, it's an arbitrary container of
>> one or more resources. Not only is this definition flexible, it's also
>> very useful, for memory hotplug, odd types of NUMA boxes, etc.
> 
> I must disagree here. Special cases are always dangerous especially
> if they are hard to regression test. I made this discovery the hard
> way on x86-64 ... It's best to eliminate them in the first place,
> otherwise they will later come back and bite you when you don't expect it.
> 
> Adding NULL tests all over mm for this would seem like a clear case
> of this to me.

I wasn't suggesting having NULL pointers for pgdats, if that's what you
mean. Just nodes with no memory in them, the pgdat would still be there.
pgdat = struct node, except everything's badly named.


