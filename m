Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbZARJzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbZARJzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 04:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZARJz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 04:55:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52592 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbZARJz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 04:55:26 -0500
Message-ID: <4972FC74.40908@redhat.com>
Date: Sun, 18 Jan 2009 11:55:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
References: <1232173776.7073.21.camel@marge.simson.net> <1232186054.6813.48.camel@marge.simson.net> <1232186877.14073.59.camel@laptop> <1232188484.6813.85.camel@marge.simson.net> <1232193617.14073.67.camel@laptop> <1232194752.6273.5.camel@marge.simson.net> <20090117044316.bda7d0bd.akpm@linux-foundation.org> <1232198574.16303.8.camel@marge.simson.net> <20090117160115.GA31601@elte.hu> <4972E860.5080206@redhat.com> <20090118083744.GB21940@elte.hu> <4972EF6B.90207@redhat.com>
In-Reply-To: <4972EF6B.90207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> A simple test running 10 idle guests over 4 cores doesn't reproduce 
> (2.6.29-rc).  However we likely need a more complicated setup.
>

Letting the ping run for a while, I see

> --- 10.35.18.172 ping statistics ---
> 846 packets transmitted, 846 received, 0% packet loss, time 845917ms
> rtt min/avg/max/mdev = 0.131/2.572/305.452/20.236 ms

So it does reproduce.

-- 
error compiling committee.c: too many arguments to function

