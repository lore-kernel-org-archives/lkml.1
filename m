Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbXHRFfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbXHRFfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXHRFfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:35:32 -0400
Received: from 1wt.eu ([62.212.114.60]:1733 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXHRFfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:35:31 -0400
Date: Sat, 18 Aug 2007 07:28:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Xu Yang <risingsunxy@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.19 porting
Message-ID: <20070818052805.GO6002@1wt.eu>
References: <ab40e9c0708170924h5b958423jcd0e82e211ca8463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab40e9c0708170924h5b958423jcd0e82e211ca8463@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 06:24:17PM +0200, Xu Yang wrote:
> Hi everyone,
> 
> I have built up a software virtual prototype system with ARM11MPCORE.
> my system is similar with realview_eb_mpcore. but my system is
> simpler, which has only a mpcore , uart0, console,timer0_1, and
> memorys.
> 
> I want to run kernel 2.6.19 on it. I have done some modification, and
> now I can just print out some information onto the console, and stuck
> at
> 
> <7>Calibrating delay loop...
> 
> Could you guys give me some suggestion that what other adaptions
> should I do according to my system?

it's likely that one of your timers is not working. Adding a few
of printk() in the calibration function should help you.

> any suggestion is welcome:)

If you upgrade to a more recent kernel (eg: 2.6.22), you'll get
more feedback because it's fresher in people's mind.

Willy

