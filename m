Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbYEBKVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbYEBKVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYEBKVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:21:25 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:56066 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYEBKVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:21:24 -0400
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Noe <dpn@isomerica.net>,
       torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
From: Andi Kleen <andi@firstfloor.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<4818DAC4.0@isomerica.net>
	<20080430135938.82e46e67.akpm@linux-foundation.org>
	<200805010053.31894.m.kozlowski@tuxland.pl>
Date: Fri, 02 May 2008 12:20:21 +0200
In-Reply-To: <200805010053.31894.m.kozlowski@tuxland.pl> (Mariusz Kozlowski's message of "Thu, 1 May 2008 00:53:31 +0200")
Message-ID: <87od7pf1ne.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 10:13:27.0204 (UTC) FILETIME=[29A9DE40:01C8AC3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski <m.kozlowski@tuxland.pl> writes:
>
> Speaking of energy and time of a tester. I'd like to know where these resources
> should be directed from the arch point of view. Once I had a plan to buy as
> many arches as I could get and run a farm of test boxes 8-) But that's hard
> because of various reasons (money, time, room, energy). What arches need more
> attention? Which are forgotten? Which are going away? For example does buying
> an alphaserver DS 20 (hey - it's cheap) and running tests on it makes sense
> these days?

A lot of bugs are not architecture specific. Or when they are architecture
specific they only affect some specific machines in that architecture.
But really a lot of bugs should happen on most architectures. Just focussing
on lots of boxes is not necessarily productive.

My recommendation would be to concentrate on deeper testing (more coverage)
on the architectures you have.

A interestig project for example would be to play with the kernel gcov patch that
was recently reposted (I hope it makes mainline eventually). Apply that patch,
run all the test suites and tests you usually run on your favourite test box
and check how much of the code that is compiled into your kernel was really tested
using the coverage information Then think: what additional tests can you do to get 
more coverage?  Write tests then? Or just write descriptions on what is not tested 
and send them to the list, as a project for others looking to contribute to the 
kernel.

-Andi
