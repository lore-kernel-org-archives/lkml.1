Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbXI1LI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbXI1LI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXI1LIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:08:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:16434 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXI1LIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=W6uhNkktb9BrNeNp2dZ+nSVVoKxyWyKHNeUHOl+VZp44HsOJ547+ND7ojOSRfxP669ajjtnnnSlXlQARVoIti/qQ5h1noWryT0rqifTecL2vJKazz8DX7SfTdAnMlHk92K0Va+otesIJlp4mQOlAabJaiR6FSjiKCwBCh0rj9qQ=
Date: Fri, 28 Sep 2007 19:03:10 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928110310.GF2443@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org> <200709281246.45546.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709281246.45546.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 12:46:45PM +0200, Christian Borntraeger wrote:
>Am Freitag, 28. September 2007 schrieb Andy Whitcroft:
>> > And this is not about any particular false positive. I dont mind an 
>> > "advanced mode" non-default opt-in option for the script, if someone is 
>> > interested in borderline or hard to judge warnings too, but these 
>> > default false positives are _lethal_ for a tool like this. (and i made 
>> > this point before.) This is a _fundamental_ thing, and i'm still not 
>> > sure whether you accept and understand that point. This is very basic 
>> > and very important, and this isnt the first (or second) time i raised 
>> > this.
>> 
>> You are striving for a level of perfection that is simply not achieveable.
>
>I dont think Ingo is looking for perfection. Its about a different 
>optimization goals.
>
>Let me put it this way:
>
>checkpatch in advanced mode:
>- I want to be able to see as many possible problems (this is the optimization 
>goal)
>- I accept that I get false positives
>- not useful for git and mail traffic
>
>checkpatch in safe mode:
>- I never want a false positive (different optimization goal!)
>- I accept that I will miss several real bugs because several tricky tests are 
>disabled
>- useful for git and mail traffic
>

Maybe checkpatch.pl needs an option '-W' to turn on/off those vexed "noise".
(It seems that 'q|quiet' doesn't do as much as what it hints.)

;-)

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

