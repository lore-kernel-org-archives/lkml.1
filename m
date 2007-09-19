Return-Path: <linux-kernel-owner+w=401wt.eu-S1763831AbXISRmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763831AbXISRmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763425AbXISRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:42:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49781 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763773AbXISRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:42:03 -0400
Message-ID: <46F15F5F.9060908@us.ibm.com>
Date: Wed, 19 Sep 2007 10:41:51 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com> <20070919162018.GA16237@infradead.org> <20070919095223.83bd8226.randy.dunlap@oracle.com>
In-Reply-To: <20070919095223.83bd8226.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 19 Sep 2007 17:20:18 +0100 Christoph Hellwig wrote:
> 
>> On Wed, Sep 19, 2007 at 07:14:47AM -0700, David Wilder wrote:
>>> I agree with you; however, this is in the example code in the 
>>> Documentation directory,  It is not part of the trace code.  The example 
>>> was just meant to be a demonstration of how the interface works.
>> So we tell people to write bad code?  Wonderful..
>>
>> And while we're at it can we please stop the dumb idea to put example
>> code into Documentation?  If example code doesn't get build during a
>> make oldconfig it will bitrot real fast and not be useful at all.
> 
> 
> That's why they exmaples should not be hidden/embedded in .txt files;
> they should be standalone .c files with makefiles etc.
> 
> I've built and corrected several of them, but they would be more
> likely to be kept up-to-date if they are more available in standalone
> files.
> 
> and they can be taken out of Documentation/ whenever they go into
> util-linux-ng or elsewhere.  Let's get the order correct.
> 
> ---
> ~Randy
> 
IMHO keeping example code as standalone files under Documentation/* make 
it easy to build an play with.  I like it better than keeping it on some 
project website where it is even less likely to maintained.
