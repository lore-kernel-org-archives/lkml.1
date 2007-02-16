Return-Path: <linux-kernel-owner+w=401wt.eu-S1423310AbXBPGHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423310AbXBPGHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423312AbXBPGHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:07:20 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:54739 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423310AbXBPGHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:07:18 -0500
Message-ID: <45D54A0E.5090106@nortel.com>
Date: Fri, 16 Feb 2007 00:07:10 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: v j <vj.linux@gmail.com>
CC: Scott Preece <sepreece@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org> <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com> <7b69d1470702151705h297c3b38g138eb0138b900aea@mail.gmail.com> <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
In-Reply-To: <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2007 06:07:14.0264 (UTC) FILETIME=[B4225D80:01C75190]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j wrote:

> Greg
> KH has gone and made the basic sysfs interface, which any generic
> driver could use as EXPORT_SYMBOL_GPL.
> ...The point is that old functionality is being ripped
> off and new ones introduced, and their interfaces are not open
> anymore.

Hmm...you keep using the word "open".  What definition are you using? 
Because the new implementation is licensed under the GPL, which is an 
"Open Source" license.  By definition, this means that it is "open".

What I see you saying is that the interfaces are more restrictive than 
before.  This is true.

However, if you are confident that you are abiding by the terms of the 
GPL then there is nothing stopping you from patching the kernel to 
convert the EXPORT_SYMBOL_GPL to just EXPORT_SYMBOL.  The _GPL version 
is just a hint as to the intent/opinion of the designer.

The flip side of that is that using only items exported via 
EXPORT_SYMBOL doesn't make you automatically compliant to the GPL.  You 
could still be infringing if the module is legally considered a 
derivative work of the kernel.

Chris
