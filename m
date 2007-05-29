Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbXE2RAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbXE2RAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbXE2RAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:00:09 -0400
Received: from rtr.ca ([64.26.128.89]:4277 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbXE2RAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:00:07 -0400
Message-ID: <465C5C16.7020001@rtr.ca>
Date: Tue, 29 May 2007 13:00:06 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 29 May 2007, Mark Lord wrote:
>> There are a zillion USB patches in 2.6.22-rc*.
>> Greg: got any good suggestions on which one to revert first?
> 
> Any chance of bisecting it?

Ugh.  Is there a way to tell bisect to only work around the USB updates?
I suppose so.. just pick the commits before and after the USB dump
and let it pick through the middle.

Still, that'll take a few hours, and frankly I'm getting sick of having
to re-debug the USB layer with each new kernel rev.

Got a pointer to the "bisect how-to" ?

Thanks
