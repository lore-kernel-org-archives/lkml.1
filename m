Return-Path: <linux-kernel-owner+w=401wt.eu-S1946565AbXD3VXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946565AbXD3VXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946824AbXD3VXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:23:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946565AbXD3VXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:23:16 -0400
Message-ID: <46365E3F.9070109@redhat.com>
Date: Mon, 30 Apr 2007 17:23:11 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Manuel Metz <mmetz@astro.uni-bonn.de>
CC: linux-kernel@vger.kernel.org, nappers@gmail.com,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: PROBLEM: oops in 2.6.21.1 after bringing up the network
References: <8fgo8-1wP-9@gated-at.bofh.it> <4635D7B1.2040001@astro.uni-bonn.de>
In-Reply-To: <4635D7B1.2040001@astro.uni-bonn.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Metz wrote:
> Brett Ryland wrote:
>> Hi,
>> I am consistently getting a kernel oops from a vanilla 2.6.21.1 kernel. It 
>> also occurs in vanilla 2.6.21, but not in 2.6.20.8. The relevant section of 
>> the kernel is networking, in particular the sis900 module (I think).
>> The attached file contains the oops and the information asked for on the site 
>> http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html for reporting 
>> kernel oopses. The oops fully crashes my computer and leaves the capslock and 
>> numlock leds flashing, so the oops is transcribed by hand from a photo 
>> (hopefully I haven't made a mistake, I do still have the photo if it's 
>> needed).
>>
>> I'm not subscribed to the mailing list so please CC any questions/solutions to 
>> me.
>>
>> Regards,
>> Nappers.
> 
> Hi, I have the same problem here on an ASUS laptop with sis network
> card. The system worked fine with kernel 2.6.21-rc7-mm2 and 2.6.20.7,
> but crashes with 2.6.21.1.
> 

Fixed by this:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=dc5a144991ba803bc8afded105c9db1dea0e57ab

Look here before reporting bugs to linux-kernel:
http://kernelnewbies.org/known_regressions
