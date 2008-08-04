Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYHDN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYHDN0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYHDN0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:26:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbYHDN0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:26:05 -0400
Message-ID: <4897032E.5020601@linux-foundation.org>
Date: Mon, 04 Aug 2008 08:25:02 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC:Patch: 000/008](memory hotplug) rough idea of pgdat removing
References: <20080801180522.EC97.E1E9C6FF@jp.fujitsu.com> <489314FE.7080900@linux-foundation.org> <20080802090335.D6C8.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20080802090335.D6C8.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:

>>> Thanks for your comment.
>> Duh. Then the use of RCU would also mean that all of reclaim must
>>  be in a rcu period. So  reclaim cannot sleep anymore.
> 
> I use srcu_read_lock() (sleepable rcu lock) if kernel must be sleep for
> page reclaim. So, my patch basic idea is followings.

But that introduces more overhead in __alloc_pages.
