Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYJ3Pbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYJ3Pbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbYJ3PbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:31:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:50724 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYJ3PbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=Yuwj1j2tTHGThL4U2y+63lP72reOseaE4RtWL5+WZJf3kKZsZX0otqhMfZ+oKdNGxC
         9dMiWt5jg0nSPJdueCcQ80mnbjjOC8WLUTX30SbBdu0JCe65p0RWO1jBH4NdtpwSdde3
         xef5rLUze1Mcr3qHD3hyNtvAobhWxH/RwWGSk=
Message-ID: <4909D33B.4050108@tuffmail.co.uk>
Date: Thu, 30 Oct 2008 15:31:07 +0000
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] API for system clocks (oscillators)
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
In-Reply-To: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Bonn wrote:
> I'd be happy to get some feedback on this, whether or not it is a good
> idea or even the right way to approach this problem.  This is part of
> the puzzle for solving the problem of frequency scaling on (primarily)
> embedded systems where there are many clocks, (changeable)
> relationships between clocks, device dependencies on clock
> availability, and device constraints on frequency that appear and
> disappear as devices are enabled and disabled.
> 
> This is a first draft (almost thinking-out-loud version), so please
> read it as such... there is much room for improvement and all
> suggestions are welcome.  Release early, release often, right?  Well,
> this is an "early" specification...

Hmm, how does this relate to the OMAP clock domain work?  I read about
it on LWN and was impressed...

omap2-clock merge: <http://thread.gmane.org/gmane.linux.ports.arm.omap/9464>

Len's OLS notes: <http://lwn.net/Articles/292447/>

Regards
Alan
