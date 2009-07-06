Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZGFVWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZGFVWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZGFVWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:22:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZGFVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:22:00 -0400
Message-ID: <4A526AEF.3070407@zytor.com>
Date: Mon, 06 Jul 2009 14:21:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexey Vlasov <renton@renton.name>
CC: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: devpts mounts too slowly
References: <20090603142801.GC21646@beaver.vrungel.ru> <4A26EB18.6060907@zytor.com> <20090609161945.811cc01f.akpm@linux-foundation.org> <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com> <4A2EF833.6080300@zytor.com> <20090706195252.GA7484@beaver.vrungel.ru>
In-Reply-To: <20090706195252.GA7484@beaver.vrungel.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Vlasov wrote:
> On Tue, Jun 09, 2009 at 05:02:59PM -0700, H. Peter Anvin wrote:
> 
>> A quick script seems to confirm that the time starts creeping up as the
>> number of mount points increase; on my Core i7 system the 10000th mount
>> takes around 50 ms whereas the early instances are submillisecond, and
>> the increase *seems* to be O(n log n) or thereabouts -- slightly
>> superlinear but not a good fit for a power law.
> 
> I have prepared a new machine for testing, and I don't see any slowdown
> by mounting devpts.
> Total mounts on it:
> # wc -l /proc/mounts
> 153481 /proc/mounts
> # fgrep -c devpts /proc/mounts
> 10231
> 
> On my other servers there're slowdown already by this number of:
> # wc -l /proc/mounts
> 49889 /proc/mounts
> # fgrep -c devpts /proc/mounts
> 3323
> 
> But the first box is totally empty, others are in use, may be this
> matters?
> 

Do you have /selinux mounted on one of them?

	-hpa

