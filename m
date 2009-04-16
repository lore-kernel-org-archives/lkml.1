Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZDPVGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZDPVGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZDPVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:06:09 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:59066 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZDPVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:06:07 -0400
Message-ID: <49E79D33.4010909@cs.columbia.edu>
Date: Thu, 16 Apr 2009 17:03:47 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/30] cr: deal with nsproxy
References: <20090410023809.GT27788@x200.localdomain> <20090416205503.GA28928@us.ibm.com>
In-Reply-To: <20090416205503.GA28928@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
>> To save nsproxy, or to not save nsproxy?
>>
>> Don't think much, save it.
>>
>> I argue that nsproxy should be removed totally, if someone thinks otherwise. ;-)
> 
> You've got Oren starting to agree with you too.  I personally don't
> much care in principle, and your code looks very nice.

Heh ... as a matter of fact I always agreed with him about that.
(and the irc logs can tell the story :)

In fact, we have much more in agreement than none. That's what
I have been arguing !  Now it's time to settle the disagreements...

Oren.

> 
> The way you do this and the uts patch, though, you (of course) bypass
> the CAP_SYS_ADMIN check in copy_namespaces().  Which is fine for your
> patchset, but a problem if we were to base a compromise patchset on
> your patchset.
> 
> It of course also enforces the 'leakage' checks, which again is
> subject to our whole-container c/r discussion.
> 
> But again, the code is nice, and I see no problems in it.
> 
> -serge
> 
