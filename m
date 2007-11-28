Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbXK1XRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbXK1XRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbXK1XRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:17:42 -0500
Received: from rtr.ca ([76.10.145.34]:3168 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXK1XRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:17:41 -0500
Message-ID: <474DF713.5070102@rtr.ca>
Date: Wed, 28 Nov 2007 18:17:39 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Oops in USB / dev code plugging/unplugging multi flash
 reader
References: <474DC95B.7000201@rtr.ca> <20071128202708.GA3809@suse.de>
In-Reply-To: <20071128202708.GA3809@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Nov 28, 2007 at 03:02:35PM -0500, Mark Lord wrote:
>> While testing a new USB reader/cable today,
>> I was plugging/unplugging the USB multi-flash reader (22 in 1),
>> and produced this weird oops.
>>
>> There's a locking problem in there somewhere, Greg.
>>
>> 2.6.23.8
> 
> Can you duplicate this without the closed source ATI graphics driver loaded?
..

I don't know if I can reproduce it easily regardless.
But that fglrx module has ZERO users, so it was completely benign here
(I've now deleted it from my system).

The tracebacks clearly show USB/dev error.

Cheers
