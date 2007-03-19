Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbXCSBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbXCSBHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 21:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXCSBHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 21:07:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbXCSBHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 21:07:18 -0400
Message-ID: <45FDE202.80807@redhat.com>
Date: Sun, 18 Mar 2007 21:06:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH take3 00/20] Make common x86 arch area for i386 and x86_64
 - Take 3
References: <20070315051337.488091591@goodmis.org> <20070316102933.GB4185@elte.hu>
In-Reply-To: <20070316102933.GB4185@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> Once again here's an attempt to put the shared files of x86_64 and 
>> i386 into a separate directory.
> 
> what do you think about the idea i suggested: to do an x32_/x64_ prefix 
> (or _32/_64 postfix), in a brute-force way, _right away_. I.e. do not 
> have any overlap of having both arch/i386/ and arch/x86_64/ and 
> arch/x86/ - move everything to arch/x86/ right now.

No, no, please don't do that. It would make backporting patches
for stable kernels a real pain.  Moving only the common files 
is the right way to go for a first cut...

