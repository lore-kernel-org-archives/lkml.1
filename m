Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbXDDQKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbXDDQKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXDDQKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:10:35 -0400
Received: from gw.goop.org ([64.81.55.164]:39743 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbXDDQKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:10:34 -0400
Message-ID: <4613CDE8.2000806@goop.org>
Date: Wed, 04 Apr 2007 09:10:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable
 entries
References: <20070402055652.610711908@goop.org> <20070402055704.278590661@goop.org> <200704020812.18320.ak@suse.de> <46136F25.7030907@goop.org> <20070404095745.GA16726@elte.hu> <4613C7AB.5020509@goop.org> <20070404154655.GA31804@elte.hu>
In-Reply-To: <20070404154655.GA31804@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> sure. i simply took the middle numbers. But there's definitely a 'few 
> percents' trend in the numbers.
>   

Yep. I guess the thing that coloured my summary is that I found overhead
of unpatched paravirt_ops calls surprisingly small.  I was really
expecting more like ~10% hit, but only null syscall approached that.

>>> this is not 'barely measurable' but 'BLOODY LARGE' overhead.
>>>       
>> Yes.  Fortunately there's a noticable difference between native and 
>> unpatched paravirt, because it shows all the effort we put into 
>> patching is worthwhile.
>>     
>
> if only it were not such an ugly piece of code? ;)
>   

Sigh, yes.  I've cleaned it up a bit since the last post, and commented
it, but I couldn't do much with its essential ugliness.  But I guess it
just got promoted from "ugly" to "ugly but necessary".

    J
