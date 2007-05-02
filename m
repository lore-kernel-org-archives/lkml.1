Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbXEBCZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbXEBCZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXEBCZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:25:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57890 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbXEBCZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:25:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
References: <alpine.DEB.0.98.0705011054060.12931@sigma.j-a-k-j.com>
	<20061127165138.GA2991@lst.de>
	<20070430040213.BF9901801A4@magilla.sf.frob.com>
	<20070430091121.GC31397@infradead.org>
	<20070430100917.439ebfc8.akpm@linux-foundation.org>
	<a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
	<Pine.LNX.4.64.0705011058330.27246@anakin>
	<1178028973.2875.78.camel@pmac.infradead.org>
	<9185.1178035627@redhat.com>
Date: Tue, 01 May 2007 20:18:51 -0600
In-Reply-To: <9185.1178035627@redhat.com> (David Howells's message of "Tue, 01
	May 2007 17:07:07 +0100")
Message-ID: <m1y7k8x910.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:
>
>> 	if (veryverylengthycondition1
>> 		&& smallcond2
>> 		&& (conditionnumber3a
>> 			|| condition3b)) {
>> 		...
>> 	}
>> 
>> Clear, crisp, and 80-wide. I also like how the logical operator on the 
>> following line is indented slightly into the condition of the previous 
>> line.
>
> The brain works better when associated things are lined up, so:
>
> 	if (veryverylengthycondition1 &&
> 	    smallcond2 &&
> 	    (conditionnumber3a ||
> 	     condition3b)) {
>
> is better as it gives a visual clue to association.

Not lining up with the code following the if statement is also
a plus.  Because it clearly delineates the conditions from the code.

Of course in many cases conditions this complex are candidates for

if (!condition1)
	continue;
if (!condition2)
	continue;
if (!condition3a && !condition3b)
	continue;

Eric
