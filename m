Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXEACtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXEACtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXEACtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:49:17 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbXEACtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:49:15 -0400
Message-ID: <4636AA95.3090204@zytor.com>
Date: Mon, 30 Apr 2007 19:48:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, Vivek Goyal <vgoyal@in.ibm.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org> <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org> <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <m18xc9344o.fsf@ebiederm.dsl.xmission.com> <463670D1.3000003@goop.org> <m14pmx31bw.fsf@ebiederm.dsl.xmission.com> <463678BA.5080609@zytor.com> <20070501033931.GI25929@bingen.suse.de>
In-Reply-To: <20070501033931.GI25929@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> It's still unclear to me why exactly you want to rewrite it?
> Are there any particular bugs in the current code you want to fix?
> 

It's more the sheer degree of unmaintainability which is grating on my
nerves.  There is way too much hocus-pocus going on, and I dare to say
that probably noone understands what actually happens in there.

In response to the question about what the code looks like, I have put a
development snapshot patch at:

http://userweb.kernel.org/~hpa/setup-snapshot-2007.04.30.patch

Note that it compiles, but it doesn't work yet.  This is not a
submission, just a "what does the code actually look like" sample.

	-hpa
