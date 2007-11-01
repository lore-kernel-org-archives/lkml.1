Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbXKAPFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbXKAPFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXKAPFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:05:46 -0400
Received: from sacred.ru ([62.205.161.221]:50472 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbXKAPFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:05:45 -0400
Message-ID: <4729EB3C.9050102@openvz.org>
Date: Thu, 01 Nov 2007 18:05:32 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> <4729E936.4040400@redhat.com>
In-Reply-To: <4729E936.4040400@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 01 Nov 2007 18:05:30 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Pavel Emelyanov wrote:
>> With this set we'll be able to mark pid namespaces as EXPERIMENTAL
>> or even BROKEN, so nobody will be able to crate them. So can we, please, 
>> keep things as they are for now - the appropriate fix will be ready 
>> soon.
> 
> You sound far too optimistic for my taste.  I probably haven't seen the
> proposal you have in mind but everything else I have seen simply doesn't
> work without breaking something.

The "fix" I mention is just returning -EINVAL in case user orders 
CLONE_NEWPIDS and compiling out all the namespace cloning code. This 
is just a more elegant way to get rid of pid namespaces rather than 
Ingo proposed.

Here's the root of the set:
http://lkml.org/lkml/2007/10/31/118

Thanks,
Pavel
