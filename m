Return-Path: <linux-kernel-owner+w=401wt.eu-S933880AbXCSNMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbXCSNMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933886AbXCSNMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:12:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48770 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933880AbXCSNMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:12:53 -0400
Message-ID: <45FE8BD9.9010009@redhat.com>
Date: Mon, 19 Mar 2007 09:10:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH take3 00/20] Make common x86 arch area for i386 and x86_64
 - Take 3
References: <20070315051337.488091591@goodmis.org> <20070316102933.GB4185@elte.hu> <45FDE202.80807@redhat.com> <20070319121752.GC2986@holomorphy.com>
In-Reply-To: <20070319121752.GC2986@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> Ingo Molnar wrote:
>>> what do you think about the idea i suggested: to do an x32_/x64_ prefix 
>>> (or _32/_64 postfix), in a brute-force way, _right away_. I.e. do not 
>>> have any overlap of having both arch/i386/ and arch/x86_64/ and 
>>> arch/x86/ - move everything to arch/x86/ right now.
> 
> On Sun, Mar 18, 2007 at 09:06:10PM -0400, Chuck Ebbert wrote:
>> No, no, please don't do that. It would make backporting patches
>> for stable kernels a real pain.  Moving only the common files 
>> is the right way to go for a first cut...
> 
> As if the patches come remotely close to applying in the first place.
> The filename patched is the least of the worries.

Actually it's surprising how many patches do apply unchanged.
A massive file rename, *just for the sake of renaming*, would
mean no x86 patches would apply and gain nothing anyway.

