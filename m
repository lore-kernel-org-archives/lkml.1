Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZIRQ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZIRQ2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZIRQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:28:33 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45598 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbZIRQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:28:32 -0400
Date: Fri, 18 Sep 2009 12:28:36 -0400
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org
Subject: Re: free_initrd_mem() corrups mm state on m68knommu.
Message-ID: <20090918162836.GI23702@csclub.uwaterloo.ca>
References: <20090915214959.GB23702@csclub.uwaterloo.ca> <20090916154545.GC23702@csclub.uwaterloo.ca> <4AB1E68D.90505@snapgear.com> <20090917151908.GW23700@csclub.uwaterloo.ca> <4AB2C983.3000808@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB2C983.3000808@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 09:42:59AM +1000, Greg Ungerer wrote:
> Hi Lennart,
>
> Lennart Sorensen wrote:
>> On Thu, Sep 17, 2009 at 05:34:37PM +1000, Greg Ungerer wrote:
>>> Hi Lennart,
>>>
>>> Lennart Sorensen wrote:
>>>> On Tue, Sep 15, 2009 at 05:49:59PM -0400, Lennart Sorensen wrote:
> ...
>>>> OK, seems the issue was that setup.c wasn't flagging the initrd memory
>>>> range as 'reserve_bootmem' which caused extra memory to be forced into
>>>> the mm state when it was later freed.  I guess one has to be very careful
>>>> with what patches one finds lying around the internet (in this case the
>>>> uboot bootargs patch for m68knommu that we found somewhere).
>>>>
>>>> Seems to work great now, and I finally made sense of how the bootmem
>>>> map is passed and what is going where.  It all makes sense now.
>>> Can you send a patch for it?
>>> I can push it to mainline of it looks reasonable.
>>
>> Well it's a patch ontop of another patch that isn't in mainline.
>> The other patch is one that adds support for uboot passing kernel command
>> line arguments.  Want that one too?  We find it to be rather useful.
>
> Sure, send them both.

I just sent it.

-- 
Len Sorensen
