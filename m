Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0AONz5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612Ab0AONz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:55:57 -0500
Received: from wind.enjellic.com ([209.243.13.15]:37923 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab0AONz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:55:56 -0500
Message-Id: <201001151355.o0FDtMKr014513@wind.enjellic.com>
From: greg@enjellic.com
Date: Fri, 15 Jan 2010 07:55:22 -0600
In-Reply-To: Robert Hancock <hancockrwd@gmail.com>
       "Re: Memory leak makes 'Blast the Bubbles' problematic." (Jan 13,  6:56pm)
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.5 10/14/92)
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Memory leak makes 'Blast the Bubbles' problematic.
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 13,  6:56pm, Robert Hancock wrote:
} Subject: Re: Memory leak makes 'Blast the Bubbles' problematic.

Hi Robert, thanks for the note.  Good day to Andrew and everyone on
the list.

> On 01/13/2010 09:48 AM, greg@enjellic.com wrote:
> > Hi, hope the week is going well for everyone.
> >
> > Unless I miss my guess there is some type of leak or other memory
> > anomaly starting in at least late model 2.6.31.x kernels.  I took a
> > snapshot of the behavior on 2.6.32.3 as well since I knew that
> > 2.6.31.11 would be considered long in the tooth by all the informed
> > intelligentia who would be looking at this...... :-)

> It looks like the system accumulated some more dcache entries, but
> those should presumably get freed up if the system needs the
> memory. The output of "vmstat 1" while the slowness is occurring
> might be more interesting..

That was my analysis as well.  I banged together a simple C program to
malloc and dirty about 700 megabytes of memory.  I ran a continuous
vmstat while I ran the program and verified that all the dcache
entries were forcibly evicted.

I'm going to have my wife play her games tonight to see if she senses
a difference in performance on the machine.  If her perception of
responsiveness improves then I need to dig a bit more and see if
performance degrades after the next updatedb run.  If so the question
becomes why her applications are not having the same effect

35 years in this business has taught me to pay a lot of attention to
what a user feels the system is doing.  After a fresh boot of the
system she was perfectly content to play games all evening.  24 hours
later I get the following.... :-)

> My memory has leaked out---help!!!  thanks  Kiss Iggs

Iggs is our Golden Retriever/her surrogate child BTW, who is sitting on my
feet down here at the lake.... :-)

I will update everyone after this next round of testing.

Best wishes for a pleasant weekend to everyone.

Greg

}-- End of excerpt from Robert Hancock

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"I use emacs, which might be thought of as a thermonuclear word processor."
                                -- Neal Stephenson
                                   In the beginning... was the command line
