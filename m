Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZHJM4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZHJM4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZHJM4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:56:41 -0400
Received: from bar.sig21.net ([80.81.252.164]:40806 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbZHJM4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:56:40 -0400
Date: Mon, 10 Aug 2009 14:56:51 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810125651.GB6082@sig21.net>
References: <20090807170942.GB9177@sig21.net>
 <87k51cgdt8.fsf@basil.nowhere.org>
 <20090810122731.GA5863@sig21.net>
 <20090810123228.GD6838@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810123228.GD6838@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.0 (----)
X-Spam-21-Report: No, score=-4.0 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.356,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 02:32:28PM +0200, Andi Kleen wrote:
> > > The appended patch should remove the warning. Can you please test it?
> > 
> > It works (no more warning), but I feel I'm better off using "lapic"
> 
> Thanks for testing.
> 
> > because it enables thermal monitoring and performance counters.
> 
> When the BIOS doesn't enable it then force enabling lapic might not work.
> 
> This could cause either boot failures (obvious) or more subtle
> problems like SMM doing something unexpected. Just saying that if you have 
> strange problems later first try disabling this option again.

Thanks for the heads-up.  I remember I tried to use oprofile
in the past on this machine and was disappointed that it only
got the timer event.  I'll keep lapic for now unless I see
signs of instability.


Johannes
