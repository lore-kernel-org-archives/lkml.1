Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbXE2QNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbXE2QNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXE2QM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:12:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55661 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXE2QM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:12:56 -0400
Message-ID: <465C50FC.8050604@austin.ibm.com>
Date: Tue, 29 May 2007 11:12:44 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <Pine.LNX.4.61.0705281123000.11140@yvahk01.tjqt.qr> <465BEBE5.5070008@shadowen.org>
In-Reply-To: <465BEBE5.5070008@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +		if(!($prevline=~/\/\*\*/) && length($lineforcounting) > 80){
>> Actually, I think this should be "> 79" (after stripping a .diff's
>> control column), since the cursor may move to the 81th column when
>> editing an 80-col line - which is what we want to avoid, no?
> 
> 80 tends to work for me because of that "if on 80 then don't wrap until
> there is another character" behaviour of most terminals.  Anyone else
> with a firm opinion.

I think 80 is good.  What the specific number is does not matter much, we all have 
screens wider than 80 characters.  The point is just to have a number that prevents 
really long lines and prevents people from indenting too many levels past our minds 
ability to keep up.  We've already all been coding to 80, and it happens to be a nice 
round number we can all remember and love.  The only reason I see to select 79 is 
that prime numbers are generally cooler than other numbers.

-Joel

