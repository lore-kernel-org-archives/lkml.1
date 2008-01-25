Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYAYJKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYAYJKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYAYJKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:10:32 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:54948 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbYAYJK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:10:28 -0500
Message-ID: <4799A773.2030702@cateee.net>
Date: Fri, 25 Jan 2008 10:10:11 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <alpine.LFD.1.00.0801241529440.15329@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801241529440.15329@hp.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 24 Jan 2008, Linus Torvalds wrote:
>> The release is out there (both git trees and as tarballs/patches), and for 
>> the next week many kernel developers will be at (or flying into/out of) 
>> LCA in Melbourne, so let's hope it's a good one.
> 
> Since I already had two kernel developers asking about the merge window 
> and whether people (including me) traveling will impact it, the plan right 
> now is to keep the impact pretty minimal. So yes, it will probably extend 
> the window from the regular two weeks, but *hopefully* not by more than a 
> few days.

As a tester, I'm not so happy.
The last few merge windows were a nightmare for us (the tester).
It remember me the 2.1.x times, but with few differences:
- more changes, so bugs are unnoticed/ignored in the first weeks or
- or people are pushing more patches possible, so they delay
   bug corrections to later times (after merge windows).

If it continues so, I should stop testing the kernel on the
merge windows (but it seems that other testers already give up
the early merge phase).

As a tester I would like:
- slow merges, so that developer could rebase and test
   (compile test) the interaction of the new code.
- you will introduce a new step on git management:
   Every changeset is compile-tested before going out to the world.
   I think this can be done automatically, and I think that one or
   two configurations are enough to find most of the problems.

Happy LCA,
ciao
	cate
