Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYAYCOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYAYCOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 21:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYAYCOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 21:14:15 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:32925 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYAYCOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 21:14:14 -0500
Message-ID: <479945ED.7040007@davidnewall.com>
Date: Fri, 25 Jan 2008 12:44:05 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com> <20080124172414.GD4476@does.not.exist> <4798D10C.6090109@davidnewall.com> <20080124181442.GE4476@does.not.exist>
In-Reply-To: <20080124181442.GE4476@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Jan 25, 2008 at 04:25:24AM +1030, David Newall wrote:
>   
>> The performance benefit is trivial, and the improvement to
>> maintainability is even less.
>>     
>
> The effects become bigger when you realize that there are many such 
> places in the kernel.
>
> And the benefit of keeping it is zero.
>   

The benefit is not zero.  Repeating myself: While the code is there, it
encourages either removal or repair.  If the option to remove is taken
off the table then it will eventually be repaired.

> What you are doing is not contributing but wasting other people's time.
>   
You want to remove the code so you attack me.  Sadly for you, your
personal taste is irrelevant to the benefit that I bring.  What kind of
a person considers robust debate to be a waste of time?  A  bit
pathetic, sadly.

> The only thing you could ever achieve with this kind of "contribution" 
> is to end up in some killfiles.
>   

I'm comfortable with that.  I'm also comfortable that consensus might go
against me.  This childish threat of kill-files is not going to stop me.

>>>> At one stage iBCS2 support DID work.  Now it doesn't.  Now there's an
>>>> argument that the remaining infrastructure should be removed.  This is
>>>> the wrong direction to take.
>>>>     
>>>>         
>>> When did iBCS2 support work in a plain ftp.kernel.org kernel?
>>>   
>>>       
>> I don't know when.  Are you disputing that it ever did?  I think it's a
>> given that once it worked.
>>     
>
> AFAIK the kernel never shipped with iBCS2 support.
>   

Are you claiming that it never did?  Is that even important?  Clearly
there was support for it in the mainline kernel.  Anecdotally the
support worked.

...
> The point is that ideas do not turn themselves into code.
>   
This discussion is about removing code.  That's a bit like tearing down
the pergola because the vine has shrivelled.  Easy to do, but
counter-productive.  LIkewise, removing iBCS2 code would be
unproductive.  It would achieve no benefit, whilst simultaneously
leading Linux in the wrong direction.  This is a point you have
consistently failed to address.

> And there are far too many people who want to see their great ideas 
> implemented without implementing it themselves.
>   
This is not about a great idea.  It's about a pointless idea.  Even
allowing what you say to be true, and it probably is, there is nothing
wrong with somebody having a great idea and leaving it to others to
implement.  If the only people allowed to have great ideas were those
who could implement them then the world would be a much poorer place. 
You demonstrate a twisted view of value.

> Talking about a feature without having anyone willing to implement it 
> simply has no value.

Who said nobody is willing to implement it?  We've all recently learned
that there is a patch.  From there to implementation is much closer than
you or I thought last week.  So already this discussion has prompted
tangible benefit.
