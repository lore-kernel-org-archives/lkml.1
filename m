Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbXESSNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbXESSNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbXESSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:13:38 -0400
Received: from main.gmane.org ([80.91.229.2]:58075 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbXESSNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:13:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philip Pemberton <usenet07@philpem.me.uk>
Subject: Re: IPv6: 6to4 tunnel randomly cutting out on 2.6.8.1 - any   patches?
Date: Sat, 19 May 2007 19:12:52 +0100
Message-ID: <f2nen4$q30$1@sea.gmane.org>
References: <f2ifnf$ooh$1@sea.gmane.org> <20070517.143409.102123884.davem@davemloft.net> <f2iif3$3u3$1@sea.gmane.org> <Pine.LNX.4.61.0705190950370.9015@yvahk01.tjqt.qr> <20070519164802.GA10510@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 87-194-114-122.bethere.co.uk
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
In-Reply-To: <20070519164802.GA10510@ee.oulu.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Pietikainen wrote:
> If you feel like spending lots of time, you could try to shoehorn net/*
> from the latest rhel4/centos4 kernel (2.6.9-based) into your router, someone
> might have spent the effort fixing the relevant bugs in that tree (but maybe
> not, until the 4.5 kernel it used to spew Badness in dst_release at
> include/net/dst.h:149 every few seconds if your box was on a ipv6 network :D
> )

I could do that, but shoehorning 2.6.9 code into 2.6.8.1 doesn't sound like 
much fun, especially transplanting the whole networking stack...

What I have found are all the IPv6-related patches from 2.6.8.1 to 2.6.9 
(there aren't that many) so I might have a go at patching the kernel with them.

> Personally, I'd get a new router without binary blobs, value of time spent
> doing the shoehorning > price of new router, I'm sure, but you may value
> your free time differently :)

I've got five weeks off to do with as I please. I need something to do, 
otherwise I'm going to go mad :)

> I do know sixxs ipv6 tunnels are rock solid with openwrt (2.4-based) ;)

Hmm, I've got a source pack for a version of the DG834GT firmware that was 
based on an older kernel (2.4.17) - is IPv6 in 2.4.17 generally considered to 
be quite stable?

If it is, I'll have a go at shoehorning my RC scripts onto the older firmware 
and maybe try and transplant the ADSL line controller firmware too...

Thanks.
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
usenet07@philpem.me.uk        | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.
If mail bounces, replace "07" with the last two digits of the current year.

