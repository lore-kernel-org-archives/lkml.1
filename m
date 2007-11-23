Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbXKWBZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbXKWBZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXKWBZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:25:18 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46968 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXKWBZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:25:17 -0500
Date: Thu, 22 Nov 2007 19:24:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC] Documentation about unaligned memory access
In-reply-to: <fa.U+CIv4JClOmn6KppLkEOSk7RW0Y@ifi.uio.no>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-id: <47462BBC.2000206@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.U+CIv4JClOmn6KppLkEOSk7RW0Y@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Being spoilt by the luxuries of i386/x86_64 I've never really had a good
> grasp on unaligned memory access problems on other architectures and decided
> it was time to figure it out. As a result I've written this documentation
> which I plan to submit for inclusion as
> Documentation/unaligned_memory_access.txt
> 
> Before I do so, any comments on the following?

...

> You may be wondering why you have never seen these problems on your own
> architecture. Some architectures (such as i386 and x86_64) do not have this
> limitation, but nevertheless it is important for you to write portable code
> that works everywhere.

Also, x86 doesn't prohibit unaligned accesses, but I believe they have a 
significant performance cost and are best avoided where possible.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

