Return-Path: <linux-kernel-owner+w=401wt.eu-S969047AbXEHXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969047AbXEHXBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967774AbXEHXB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:01:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37959 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967801AbXEHXBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:01:25 -0400
Message-ID: <46410140.7050205@garzik.org>
Date: Tue, 08 May 2007 19:01:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: start flamewar about use of braces
References: <200705081903.l48J3AOw010373@hera.kernel.org> <20070508124301.17975a4f.randy.dunlap@oracle.com> <4640E971.9050400@garzik.org> <20070508222540.GG8753@csclub.uwaterloo.ca> <4640FEA0.3020407@seclark.us>
In-Reply-To: <4640FEA0.3020407@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> Lennart Sorensen wrote:
>> On Tue, May 08, 2007 at 05:19:45PM -0400, Jeff Garzik wrote:
>>> If anyone tries to add braces to my code's 'else' statements where 
>>> they are not required, that patch will get NAK'd in a heartbeat.

>> Oh isn't coding style fun.  I personally hate code that doesn't ALWAYS
>> have the braces everywhere since it makes adding a print statement
>> or other debuging to the condition such a pain since you then have to
>> add braces to the condition to avoid breaking the code just to insert
>> a print statement.  It is one of the few things I disagree with in the
>> linux kernel coding style.

> I agree - it is merely defensive programming to always have the braces, 
> it prevents someone
> from sticking in a diag and forgetting to add braces so things go haywire.


If you compulsively add braces where not needed, the number of lines in 
the source file explodes.  Net result is code that is more difficult to 
read, because far fewer lines of code fit on a single page/screen.

But hey, it's personal preference.  I'm not going to enforce the 
make-code-more-readable rule on others' code... :)

	Jeff


