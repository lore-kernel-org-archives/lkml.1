Return-Path: <linux-kernel-owner+w=401wt.eu-S1765421AbYEIQWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765421AbYEIQWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764751AbYEIQWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:22:08 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:32821 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764697AbYEIQWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:22:01 -0400
Date: Fri, 9 May 2008 17:21:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Glauber Costa <glommer@gmail.com>
cc: "Theodore Ts'o" <tytso@mit.edu>, Glauber Costa <gcosta@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Possible regression? 2.6.26-rc1: T61s failure after suspend/resume
In-Reply-To: <5d6222a80805090828j1a1af054y547640c3408bca1b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805091706390.11688@blonde.site>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org>  <Pine.LNX.4.64.0805082148060.3994@blonde.site>
 <5d6222a80805090828j1a1af054y547640c3408bca1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Glauber Costa wrote:
> 
> I can't reproduce it neither, and looking at the code over and over
> again, see no obvious point for the breakage. I'll try to reproduce it
> myself,
> to see if I can spot something. But correct me if I'm wrong, this is
> all 64-bit machines, right?
> 
> I'm stuck with mostly 32-bit hardware, but will give it a try anyway.

The machine is 64-bit capable (Core2 Duo), but the kernels I'm running
for this are 32-bit, so I doubt that the 64-bitability is relevant.
I'd love to see what happens with a 64-bit kernel, but I never get
back from suspend with it (and that's not a recent regression).
Carlos is also seeing this with a 32-bit kernel (on P4 Xeon with HT).

Please don't take my git bisection result too seriously: that's where
it led when I fudged things around enough, and treated blank screens
as manifestations of the problem, which very likely they're not
(there's some other bug which makes it very variable how quickly
I resume).  And also, I wasn't checking how many cpus came up each
time: I wouldn't be surprised if at some points in your series only
one would come up, which would then look like a "good" point to me.

Thanks,
Hugh
