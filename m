Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZHFBVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZHFBVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZHFBVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:21:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZHFBVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:21:45 -0400
Date: Wed, 5 Aug 2009 21:21:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dave Airlie <airlied@gmail.com>
cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: Please revert fc4c73554c9d93b3e495f2f7acae1323b0d5db84. Re: 
 [PATCH 1/2] ftrace: Fix the conditional that updates $ref_func
In-Reply-To: <21d7e9970908051817u2f630d2ai2d4435fb79601bbb@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0908052120570.5010@gandalf.stny.rr.com>
References: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>  <alpine.DEB.2.00.0908051525070.23591@gandalf.stny.rr.com>  <alpine.DEB.2.00.0908051720350.23591@gandalf.stny.rr.com> <21d7e9970908051817u2f630d2ai2d4435fb79601bbb@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Aug 2009, Dave Airlie wrote:

> Doesn't seem to work here, I put the patch in on top of the Fedora
> kernel instead of the previous one and got a link failure again in lm93.o
> 
> I'll reconfirm it now.
> 

This is weird. I took the object file out of the build and got it to work 
with this patched recordmcount.pl script, but when I do it in the build it 
doesn't work. I'm still investigating.

-- Steve

