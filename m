Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbYB2Q4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbYB2Q4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYB2Q4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:56:09 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:65245 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYB2Q4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:56:08 -0500
Message-ID: <47C838C5.8030707@nortel.com>
Date: Fri, 29 Feb 2008 10:54:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Roskin <proski@gnu.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only symbols
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Feb 2008 16:54:32.0450 (UTC) FILETIME=[C1A4BE20:01C87AF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Pavel Roskin wrote:
> 
>>>I'm not seeing why ndiswrapper should be treated separately.
>>
>>It is already treated separately, and has been for a long time.
> 
> 
> No, I mean "separately from the thing it loads".
> 
> It loads non-GPL code, it is non-GPL.

But the GPL only applies to derivative works.  Given that ndiswrapper 
loads binaries designed for another OS, doesn't that mean that it is 
unlikely that the binaries would be impacted by the GPL?

So the portion that is a derivative work (ndiswrapper itself) is GPL, 
and it loads something that is clearly not a derivative work.  From a 
licensing standpoint how is this different than an open-source driver 
loading a proprietary firmware?

Once ndiswrapper loads the binary blob the kernel should be considered 
tainted from a debuggability standpoint, but I have some sympathy for an 
argument suggesting that ndiswrapper should be able to use GPLONLY symbols.

Chris
