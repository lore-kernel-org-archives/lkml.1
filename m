Return-Path: <linux-kernel-owner+w=401wt.eu-S935103AbXHNXFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103AbXHNXFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXHNXFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:05:18 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:10221 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXHNXFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:05:16 -0400
Date: Tue, 14 Aug 2007 17:05:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: kfree(0) - ok?
In-reply-to: <fa.oMJ6o9vN0dnAoFR83/o4hg1EptE@ifi.uio.no>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Message-id: <46C23520.2070805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.oMJ6o9vN0dnAoFR83/o4hg1EptE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> Hi all,
> 
> I have a quick question.
> 
> I'm trying to resurrect a patch from the Linux-tiny patch suite,
> to do accounting of kmalloc memory allocations.  In testing it
> with Linux 2.6.22, I've found a large number of kfrees of
> NULL pointers.
> 
> Is this considered OK?  Or should I examine the offenders
> to see if something is coded badly?

It's perfectly correct to do it - though, if it's done very frequently 
in certain cases, it might be more efficient to check for null before 
the kfree, to avoid the function call overhead into kfree..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

