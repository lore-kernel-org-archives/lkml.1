Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbXDYPhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbXDYPhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDYPhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:37:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49345 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXDYPhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:37:09 -0400
Message-ID: <462F75FF.5090008@oracle.com>
Date: Wed, 25 Apr 2007 08:38:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: Richard Knutsson <ricknu-0@student.ltu.se>, Jiri Bohac <jbohac@suse.cz>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
References: <20070419092339.GA13569@dwarf.suse.cz> <20070419084339.418dbe69.randy.dunlap@oracle.com> <4628B5B6.90303@student.ltu.se> <20070425082028.8ece3094.randy.dunlap@oracle.com> <alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Anthony Kazos Jr. wrote:
>>>> I think it's like it is just to be consistent with abs() in C,
>>>> which also contains labs() and llabs().
>>>>   
>>> We actually had labs() before (few months ago), but since it was not 
>>> used, and if it would it seemed better to just fix abs(), it was 
>>> removed. So I think this is the appropriate way to go.
>> Sounds like when someone actually needs labs() or llabs()
>> they can submit a patch for however they would like to use it.
> 
> However they would like to use *abs()? What different ways are possible to 
> take the arithmetic absolute value? I see record of many cases where 
> dozens of authors have macros that then get collapsed to include files. So 
> why not avoid that annoyance this time and -start- with it in the include 
> files?
> 
> Can there even be any reason beyond unnecessary pedantics to have 
> [l[l]]abs?

See Paragraph 1 above.  We do lots of functions in a manner that is
like C (or libc) so that we don't confuse developers.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
