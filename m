Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbYBEXfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbYBEXfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763392AbYBEXeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:34:44 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:51903 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763378AbYBEXel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:34:41 -0500
Message-ID: <47A8F27F.3060504@nortel.com>
Date: Tue, 05 Feb 2008 17:34:23 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se> <20080203231530.GB15692@kroah.com> <courier.47A8EDDC.0000785F@hawking.rebel.net.au>
In-Reply-To: <courier.47A8EDDC.0000785F@hawking.rebel.net.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 23:34:27.0580 (UTC) FILETIME=[A5F103C0:01C8684F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> That being said, a module can be written such 
> that it only dynamically links with the kernel.  Ndiswrapper is an 
> example of how this can be done: None of the drivers that work under 
> ndiswrapper make any direct use of the kernel, not in any way, indeed a 
> wrapper could be written for a different operating system.

The issue is all about "derivative works" in copyright law.

Ndiswrapper is in a good position because the closed-source drivers were 
originally written for another OS so it's pretty well impossible to 
argue that they are derived from linux.

However, if I were to write a new GPL shim and then a new closed-source 
module that uses the shim to access kernel symbols, it is entirely 
possible that a court could rule that my closed-source module is a 
derivative work of the linux kernel because it was written specifically 
to run on linux.

On the other hand if I were to sit down and write an OS-agnostic 
proprietary chunk of code, and then write a new GPL shim to use it under 
linux (and maybe other shim layers for other OS's as well), I _might_ be 
okay.  But I would have to be prepared to prove that the proprietary 
code was not derived from the Linux kernel.

Chris
