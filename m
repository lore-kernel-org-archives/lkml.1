Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbXCQRWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbXCQRWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 13:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXCQRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 13:22:11 -0400
Received: from smtpout06-04.prod.mesa1.secureserver.net ([64.202.165.227]:58102
	"HELO smtpout06.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752550AbXCQRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 13:22:10 -0400
Message-ID: <45FC23C0.5070903@seclark.us>
Date: Sat, 17 Mar 2007 13:22:08 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mark Hahn <hahn@mcmaster.ca>
CC: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <Pine.LNX.4.64.0703171105270.16125@coffee.psychology.mcmaster.ca>
In-Reply-To: <Pine.LNX.4.64.0703171105270.16125@coffee.psychology.mcmaster.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hahn wrote:

>>So in an attempt to summarise the situation, what are the advantages of RSDL
>>over mainline.
>>
>>Fairness
>>    
>>
>
>why do you think fairness is good, especially always good?
>
>  
>
>>Starvation free
>>    
>>
>
>even starvation is sometimes a good thing - there's a place for processes
>that only use the CPU if it is otherwise idle.  that is, they are
>deliberately starved all the rest of the time.
>
>  
>
>>Much lower and bound latencies
>>    
>>
>
>in an average sense?  also, under what circumstances does this actually
>matter?  (please don't offer something like RT audio on an overloaded machine-
>that's operator error, not something to design for.)
>
>  
>
>>Deterministic
>>    
>>
>
>not a bad thing, but how does this make itself apparent and of value 
>to the user?  I think everyone is extremely comfortable with non-determinism
>(stemming from networks, caches, interleaved workloads, etc)
>
>  
>
>>Better interactivity for the majority of cases.
>>    
>>
>
>how is this measured?  is this statement really just a reiteration of 
>the latency claim?
>
>  
>
>>Now concentrating on the very last aspect since that seems to be the sticking
>>point.
>>    
>>
>
>nah, I think the fairness and latency claims are the real issues.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
I guess I wonder what is wrong with the current scheduler? I am running 
2.6.20.2 on a whitebook
laptop with a core 2 duo 1.86ghz 2gb of mem with an intel 945 shared 
memory graphics processor.
I am currently running X with beryl have vncserver connected to my main 
system, which I am
using to write this email, I am running also firefox and both of ingo 
test programs. I also am running
a make -j4 on a kernel rebuild without having any pauses or any problem 
doing anything interactively.

So again what does this new scheduler fix?

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



