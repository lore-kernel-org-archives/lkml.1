Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbYB2TW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbYB2TW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYB2TWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:22:50 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:64588 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYB2TWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:22:49 -0500
X-Greylist: delayed 4973 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 14:22:49 EST
Message-ID: <47C847E8.3070905@nortel.com>
Date: Fri, 29 Feb 2008 11:59:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Roskin <proski@gnu.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only symbols
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <47C838C5.8030707@nortel.com> <alpine.LFD.1.00.0802290905240.17889@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802290905240.17889@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Feb 2008 17:59:07.0576 (UTC) FILETIME=[C7660B80:01C87AFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Chris Friesen wrote:
> 
>>But the GPL only applies to derivative works.  Given that ndiswrapper loads
>>binaries designed for another OS, doesn't that mean that it is unlikely that
>>the binaries would be impacted by the GPL?
> 
> 
> But that's what GPLONLY means.
> 
> What's so hard to understand? The driver may not be a derivative work, but 
> it sure as hell isn't GPL'd. 

I hope this won't dump me into the flamers filter....but here goes:

If the intent of the GPLONLY export is really to keep the symbol from 
being used by non-GPL code then I agree that ndiswrapper shouldn't be 
able to use them.

However, you yourself wrote something stating otherwise: 
(http://groups.google.ca/group/linux.kernel/msg/0066655bb1be1e4c):

'I think we _can_ do things where we give clear hints to people that "we
think this is such an internal Linux thing that you simply cannot use 
this without being considered a derived work".....So I personally don't 
see EXPORT_SYMBOL_GPL() to be a "technical measure", I see it as being 
"documentation".'

Under that interpretation, ndiswrapper should be able to make use of 
GPLONLY symbols because the binary blobs are clearly not derivative works.

Chris
