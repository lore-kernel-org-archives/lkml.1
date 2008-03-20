Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYCTOR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYCTOR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYCTORN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:17:13 -0400
Received: from rtr.ca ([76.10.145.34]:4941 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYCTORN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:17:13 -0400
Message-ID: <47E271E6.9070805@rtr.ca>
Date: Thu, 20 Mar 2008 10:17:10 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] USB: enable USB-PERSIST by default
References: <Pine.LNX.4.44L0.0803191727030.2504-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803191727030.2504-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
>  What difference in meaning do you imagine replacing
> "This" with "That" would achieve?
..

It might achieve a more understandable change log,
which then aids others in deciding whether what you
meant for the code to do, is what the code actually does.

And it appears to have worked in this case,
as you have now published a more complete description of intent.

Thanks.


> 
>>> This approach has the advantage of giving the user the ability to turn
>>> off USB-PERSIST for devices with mounted filesystems, rather than
>>> making the kernel always assume it should be on.
>> ...
> 
> What I meant (it probably wasn't very clear from the text) was that the
> approach of leaving USB-PERSIST controlled by the power/persist
> attribute and merely altering the attribute's default value is better
> than having the kernel unilaterally and unconditionally turn
> USB-PERSIST on for every device holding a mounted filesystem.  In other
> words, the approach taken by the patch is better than the approach
> suggested by Linus Torvalds.
> 
> Alan Stern

