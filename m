Return-Path: <linux-kernel-owner+w=401wt.eu-S970685AbXEHX4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970685AbXEHX4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969435AbXEHX4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:56:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54230 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967460AbXEHX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:56:04 -0400
Message-ID: <46410F1D.8060808@oracle.com>
Date: Tue, 08 May 2007 17:00:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org> <20070508121404.17bd97a6.randy.dunlap@oracle.com> <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <m3k5vj2iha.fsf@maximus.localdomain> <alpine.DEB.0.99.0705081306000.15420@chino.kir.corp.google.com> <20070508161309.c398a913.randy.dunlap@oracle.com> <alpine.DEB.0.99.0705081650530.28511@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.99.0705081650530.28511@chino.kir.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 8 May 2007, Randy Dunlap wrote:
> 
>> It's already there, isn't it?  <quote from original:>
>>
>> The only acceptable uses for "volatile" are:
>>
>>  - in _code_, i.e., for things like the definition of "readb()" etc, where we
>>    use it to force a particular access.
>>  - with inline asms
>>  - on "jiffies", for stupid legacy reasons
>>
>> </quote>
>>
>> or are you saying that you want to subject/header/title modified also?
>>
> 
> I wasn't aware that you were considering the inclusion of Linus' entire 
> email in the document.  There exists a point where CodingStyle becomes so 
> large that people choose not to read it in its entirety, so I was 
> expecting only an addition that would explicit document the acceptable and
> unacceptable uses of 'volatile' in kernel code with perhaps a link to his 
> email.

but I wouldn't put it into CodingStyle.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
