Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZIQXn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZIQXn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZIQXn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:43:27 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:34108 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750766AbZIQXn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:43:27 -0400
Message-ID: <4AB2C983.3000808@snapgear.com>
Date: Fri, 18 Sep 2009 09:42:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org
Subject: Re: free_initrd_mem() corrups mm state on m68knommu.
References: <20090915214959.GB23702@csclub.uwaterloo.ca> <20090916154545.GC23702@csclub.uwaterloo.ca> <4AB1E68D.90505@snapgear.com> <20090917151908.GW23700@csclub.uwaterloo.ca>
In-Reply-To: <20090917151908.GW23700@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennart,

Lennart Sorensen wrote:
> On Thu, Sep 17, 2009 at 05:34:37PM +1000, Greg Ungerer wrote:
>> Hi Lennart,
>>
>> Lennart Sorensen wrote:
>>> On Tue, Sep 15, 2009 at 05:49:59PM -0400, Lennart Sorensen wrote:
...
>>> OK, seems the issue was that setup.c wasn't flagging the initrd memory
>>> range as 'reserve_bootmem' which caused extra memory to be forced into
>>> the mm state when it was later freed.  I guess one has to be very careful
>>> with what patches one finds lying around the internet (in this case the
>>> uboot bootargs patch for m68knommu that we found somewhere).
>>>
>>> Seems to work great now, and I finally made sense of how the bootmem
>>> map is passed and what is going where.  It all makes sense now.
>> Can you send a patch for it?
>> I can push it to mainline of it looks reasonable.
> 
> Well it's a patch ontop of another patch that isn't in mainline.
> The other patch is one that adds support for uboot passing kernel command
> line arguments.  Want that one too?  We find it to be rather useful.

Sure, send them both.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
