Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbYC1WJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbYC1WJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYC1WJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:09:26 -0400
Received: from rtr.ca ([76.10.145.34]:2859 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbYC1WJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:09:25 -0400
Message-ID: <47ED6C93.2000809@rtr.ca>
Date: Fri, 28 Mar 2008 18:09:23 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc7: udevd compatibility issue?
References: <47ED3DDE.3030201@rtr.ca> <20080328202226.GA16799@suse.de>
In-Reply-To: <20080328202226.GA16799@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Mar 28, 2008 at 02:50:06PM -0400, Mark Lord wrote:
>> Having coerced 2.6.25-rc7 onto one notebook here,
>> we're now working on the other one.
>>
>> This one is the Dell Lattitude X1 sub-notebook, with Intel everything and 
>> 2GB.
>>
>> On boot, syslog is flooded with "uevent: unsupported action-string;" 
>> messages.
>> The messages claim "this will be ignored in a future kernel", but this is 
>> not a "future kernel".
>>
>> So, what purpose do they have in 2.6.25-rc7 ?
> 
> To tell you nicely that your userspace scripts are doing stupid things
> :)
..

How about having the message *include* the offending value that was
attempted to be written?

This would make such problems much easier to track down and fix.

-ml
