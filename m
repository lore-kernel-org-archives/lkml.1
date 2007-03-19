Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbXCSMSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbXCSMSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbXCSMSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:18:04 -0400
Received: from holomorphy.com ([66.93.40.71]:52506 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbXCSMSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:18:03 -0400
Date: Mon, 19 Mar 2007 05:17:52 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH take3 00/20] Make common x86 arch area for i386 and x86_64 - Take 3
Message-ID: <20070319121752.GC2986@holomorphy.com>
References: <20070315051337.488091591@goodmis.org> <20070316102933.GB4185@elte.hu> <45FDE202.80807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FDE202.80807@redhat.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> what do you think about the idea i suggested: to do an x32_/x64_ prefix 
>> (or _32/_64 postfix), in a brute-force way, _right away_. I.e. do not 
>> have any overlap of having both arch/i386/ and arch/x86_64/ and 
>> arch/x86/ - move everything to arch/x86/ right now.

On Sun, Mar 18, 2007 at 09:06:10PM -0400, Chuck Ebbert wrote:
> No, no, please don't do that. It would make backporting patches
> for stable kernels a real pain.  Moving only the common files 
> is the right way to go for a first cut...

As if the patches come remotely close to applying in the first place.
The filename patched is the least of the worries.


-- wli
