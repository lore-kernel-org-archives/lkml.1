Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXE3Pc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXE3Pc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbXE3Pcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:32:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40526 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXE3Pcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:32:47 -0400
Message-ID: <465D9933.2000209@oracle.com>
Date: Wed, 30 May 2007 08:33:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <465BECCC.5030001@shadowen.org> <Pine.LNX.4.61.0705292218520.11140@yvahk01.tjqt.qr> <20070529153651.d65fa07c.randy.dunlap@oracle.com> <Pine.LNX.4.61.0705301033470.11140@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705301033470.11140@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 29 2007 15:36, Randy Dunlap wrote:
>>>>>> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
>>>>>> +			print "Gotos should not be indented\n";
>>>>>> +			print "$herecurr";
>>>>>> +			$clean = 0;
>>>>>> +		}
>>>>> emacs generates one space label in front of a goto label. I wouldn't
>>>>> outlaw this.
>>>> Yep, we also now allow one space something to do with diff -p not
>>>> getting confused...
>>> Not only diff and emacs. At least joe (joe.sf.net) is another editor
> [...]
>> That's just a joe bug then.
>>
>> diff no longer requires a beginning space, at least in the testing
>> that I did it worked with no leading space on a label:.
> 
> But not everyone runs the latest and greatest. diffutils 2.8.7
> takes /^label:/ as a marker for the @@ line.

OK.  What does "marker for the @@ line" mean?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
