Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYARH5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYARH5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYARH5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:57:43 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:40347 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYARH5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:57:42 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 02:57:42 EST
Message-ID: <47905A95.4030500@cateee.net>
Date: Fri, 18 Jan 2008 08:51:49 +0100
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 17 Jan 2008, David Schwartz wrote:
>>> "const" has nothing to do with "logical state".  It has one meaning, and
>>> one meaning only: the compiler should complain if that particular type is
>>> used to do a write access.
>> Right, exactly.
> 
> So why do you complain? 
> 
> kfree() literally doesn't write to the object.
> 
>> You are the only one who has suggested it has anything to do with changes
>> through other pointers or in other ways. So you are arguing against only
>> yourself here.
> 
> No, I'm saying that "const" has absolutely *zero* meaning on writes to an 
> object through _other_ pointers (or direct access) to the object.

Hints: "restrict" is the C99 keyword for such requirement (or better
"const restrict")

BTW I think C use non const free as a BIG warning about not to be
to "smart" on optimization.

ciao
	cate
