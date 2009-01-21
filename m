Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZAUFeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZAUFeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZAUFeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:34:16 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2057 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZAUFeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:34:15 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=IibP2WHnzrZTMskJ1QEA:9 a=fUm603IMYD_svt-vg-gA:7 a=eEtXXrcoMiFeklv2ZJ4GFeSxEQUA:4
Message-ID: <4976B3D3.70501@shaw.ca>
Date: Tue, 20 Jan 2009 23:34:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: linux <linux@celticblues.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: disabling interupts
References: <49760A60.7040804@celticblues.com>
In-Reply-To: <49760A60.7040804@celticblues.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux wrote:
> Please advise if this question is OT.  (If so, where can I post it or 
> read more about said topic?)
> 
> I have an application that grabs frames from a frame grabber.  It is 
> dropping frames, sometimes, 30 frames at a time.  I suspect this is 
> occuring due to background tasks or something like that interupting the 
> app.   In the future I may go to a hard RT linux, but for now, I just 
> have time to try to reduce the number and frequency of frame drops.
> I read on some linux websites that one can disable interrupts to 
> increase performance and/or reduce latencies.
> My questions are
> 
> 1.  Is this an acceptable practice?  If not, what are my other options?
> 
> 2.  How can I do this? 
> Would I use:
>    void local_irq_save(unsigned long flags);
>    void local_irq_restore(unsigned long flags);
> 
> 
> 3.  What interupts should I consider disabling?
> 
> Ed

You haven't provided nearly enough details in order to answer this 
question. What kind of frame grabber, what driver is it using? Where do 
you think the frames are being dropped?
