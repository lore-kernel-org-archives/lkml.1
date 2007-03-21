Return-Path: <linux-kernel-owner+w=401wt.eu-S933851AbXCUWBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbXCUWBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXCUWBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:01:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbXCUWBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:01:34 -0400
Message-ID: <4601AB37.7070302@redhat.com>
Date: Wed, 21 Mar 2007 18:01:27 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sky2 still broken in 2.6.20.3
References: <4601950D.5000503@redhat.com> <20070321144052.02eb2ac7@dxpl.pdx.osdl.net>
In-Reply-To: <20070321144052.02eb2ac7@dxpl.pdx.osdl.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Wed, 21 Mar 2007 16:26:53 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
>> Transmit timeouts and locked-up adapters still occur in kernel
>> 2.6.20.3.
> 
> There is more changes in 2.6.21-rc4 please try that.

Yes, but I have to figure out how to get those to apply to
2.6.20.3. I was hoping you'd do that. :)

> I am still getting reports of timeouts with that code but
> it does recover better. It may be the case that with hardware
> flow control transmits can take an indefinite period so increasing
> the timeout value could help.
> 
>> It looks like the patch that was applied to 2.6.20.2
>> is not enough. Unfortunately that one isn't the same as what
>> went upstream. Looks like it needs to be reverted, then the two
>> upstream patches applied?
> 
> Until, unless the problem is reproducible with my hardware
> there is not much that can be done. I'll add the better recovery
> logic to for next stable cycle, but still not clear what causes
> all the timeouts.

I have a bug report and tester:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227420

