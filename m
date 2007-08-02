Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXHBWs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXHBWs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbXHBWsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:48:50 -0400
Received: from xenotime.net ([66.160.160.81]:59643 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757334AbXHBWst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:48:49 -0400
Date: Thu, 2 Aug 2007 15:54:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-Id: <20070802155434.b085219c.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
	<p73vebxmysb.fsf@bingen.suse.de>
	<Pine.LNX.4.60.0708022231160.6774@poirot.grange>
	<46B2578A.805@s5r6.in-berlin.de>
	<Pine.LNX.4.60.0708030024490.6774@poirot.grange>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007 00:36:40 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Thu, 2 Aug 2007, Robert Hancock wrote:
> 
> > Because 5 characters will not fit in a 4 character array, even without the
> > null terminator.
> 
> On Fri, 3 Aug 2007, Stefan Richter wrote:
> 
> > How should gcc know whether you actually wanted that char foo[len] to
> > contain a \0 as last element?
> 
> Robert, Stefan, I am sorry, I think, you are VERY wrong here. There is no 
> "even" and no guessing. The "string" DOES include a terminating '\0'. It 
> is EQUIVALENT to {'s', 't', 'r', 'i', 'n', 'g', '\0'}. And it contains 
> SEVEN characters. Please, re-read your K&R. Specifically, the Section 
> "Initialization" in the "Function and Program Structure" chapter (section 
> 4.9 in my copy), the paragraph about initialization with a string, which I 
> quoted in an earlier email.
> 
> And, Stefan, there is a perfect way to specify a "0123" without the '\0' - 
> {'0', '1', '2', '3'}.

We are actually a bit beyond traditional K&R, fwiw.

C99 spec that Al referred you to (available for around US$18 as a pdf)
says in 6.7.8, para. 14 (where Al said):

"An array of character type may be initialized by a character string literal, optionally
enclosed in braces. Successive characters of the character string literal (including the
terminating null character if there is room or if the array is of unknown size) initialize the
elements of the array."


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
