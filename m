Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYJQG2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYJQG2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYJQG2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:28:15 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42732 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYJQG2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:28:15 -0400
Message-ID: <48F83078.8020408@davidnewall.com>
Date: Fri, 17 Oct 2008 16:58:08 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Peter Zijlstra <peterz@infradead.org>, Peter Cordes <peter@cordes.ca>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: no way to swapoff a deleted swap file?
References: <20081015202141.GX26067@cordes.ca> <1224145684.28131.25.camel@twins> <Pine.LNX.4.64.0810162313570.26758@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0810162313570.26758@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 16 Oct 2008, Peter Zijlstra wrote:
>   
>> On Wed, 2008-10-15 at 17:21 -0300, Peter Cordes wrote:
>>     
>>> I unlinked a swapfile without realizing I was still swapping on it.
>>>       
>> I see your problem and it makes sense to look for a nice solution.
>>     
>
> although I'll willingly admit it's a
> lacuna, I don't think it's one worth bloating the kernel for.

Me too.  The kernel shouldn't protect the administrator against all
possible mistakes; and this mistake is one of them.  Besides, who's to
say it's always a mistake?  Somebody might want their swap file to have
zero links.


Do nothing.
