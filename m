Return-Path: <linux-kernel-owner+w=401wt.eu-S966211AbXDDAbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966211AbXDDAbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966214AbXDDAbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:31:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43126 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966211AbXDDAbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:31:49 -0400
Message-ID: <4612F1F0.5070209@zytor.com>
Date: Tue, 03 Apr 2007 17:31:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com>
In-Reply-To: <4612ABD7.3000201@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Davide Libenzi wrote:
>> It sucks when seen from a micro-bench POV, but does it really matter 
>> overall? The vast majority of software usually calls 
>> sysconf(_SC_NPROCESSORS_*) with very little frequency (mostly once at 
>> initialization time) anyway. That's what 50us / call?
> 
> This is not today's situation.  Yes, 10 years ago when I added the
> support to glibc it wasn't much of a problem.  But times change.  As I
> said before in this thread, OpenMP by default scales the number of
> threads used for a parallel loops depending on the number of available
> processors/cores and therefore the number must be retrieved every time
> (with perhaps minimal caching of a few secs, but this requires
> gettimeofday calls...).  All of a sudden this is not micro benchmark
> anymore.  It's a real issue which we only became aware of because it is
> noticeable in real life.

Sounds like it would need a device which can be waited upon for changes.

	-hpa
