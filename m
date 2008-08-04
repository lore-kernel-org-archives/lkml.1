Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbYHDV0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbYHDV0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbYHDV0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:26:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38416 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbYHDV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:26:12 -0400
Message-ID: <48977330.4090501@cs.helsinki.fi>
Date: Tue, 05 Aug 2008 00:22:56 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Matthew Wilcox <matthew@wil.cx>,
       Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org> <4896225D.9090203@cs.helsinki.fi> <48966B6D.604@keyaccess.nl>
In-Reply-To: <48966B6D.604@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 03-08-08 23:25, Pekka Enberg wrote:
> 
>> Matthew Wilcox wrote:
> 
>>> Do we have to once again explain that slab still outperforms slub on at
>>> least one important benchmark?  I hope Nick Piggin finds time to finish
>>> tuning slqb; it already outperforms slub.
>>
>> No, you don't have to. I haven't merged that patch nor do I intend to 
>> do so until the regressions are fixed.
>>
>> And yes, I'm still waiting to hear from you how we're now doing with 
>> higher order page allocations...
> 
> General interested question -- I recently "accidentally" read some of 
> slub and I believe that it doesn't feature the cache colouring support 
> that slab did? Is that true, and if so, wasn't it needed/useful?

I don't know why Christoph decided not to implement it. Christoph?
