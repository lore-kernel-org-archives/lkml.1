Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbXE2QVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbXE2QVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXE2QVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:21:15 -0400
Received: from gw.ac.upc.es ([147.83.30.3]:49176 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbXE2QVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:21:14 -0400
In-Reply-To: <465C50FC.8050604@austin.ibm.com>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <Pine.LNX.4.61.0705281123000.11140@yvahk01.tjqt.qr> <465BEBE5.5070008@shadowen.org> <465C50FC.8050604@austin.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B907D7E4-D348-4795-9B55-74F7392F548C@ac.upc.edu>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Subject: Re: [PATCH] add a trivial patch style checker
Date: Tue, 29 May 2007 18:20:54 +0200
To: Joel Schopp <jschopp@austin.ibm.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/2007, at 18:12, Joel Schopp wrote:

>>>> +		if(!($prevline=~/\/\*\*/) && length($lineforcounting) > 80){
>>> Actually, I think this should be "> 79" (after stripping a .diff's
>>> control column), since the cursor may move to the 81th column when
>>> editing an 80-col line - which is what we want to avoid, no?
>> 80 tends to work for me because of that "if on 80 then don't wrap  
>> until
>> there is another character" behaviour of most terminals.  Anyone else
>> with a firm opinion.
>
> I think 80 is good.  What the specific number is does not matter  
> much, we all have screens wider than 80 characters.  The point is  
> just to have a number that prevents really long lines and prevents  
> people from indenting too many levels past our minds ability to  
> keep up.  We've already all been coding to 80, and it happens to be  
> a nice round number we can all remember and love.  The only reason  
> I see to select 79 is that prime numbers are generally cooler than  
> other numbers.

We do have screens wider than 80 characters, but almost all the time  
I spend in terminal windows, they are set to 24x80 (the default  
size).  It is a matter of habit, and I bet I'm not alone.  Hence, 80  
is "annoying" not only because patches will wrap, but also because in  
some editors the 80th character will also wrap.

Just my 2 cents,

-- 
Julio M. Merino Vidal <jmerino@ac.upc.edu>


