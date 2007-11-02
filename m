Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbXKBHzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbXKBHzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXKBHzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:55:35 -0400
Received: from sacred.ru ([62.205.161.221]:60754 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbXKBHze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:55:34 -0400
Message-ID: <472AD7D6.80900@openvz.org>
Date: Fri, 02 Nov 2007 10:55:02 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org> <472A6D91.1020300@redhat.com>
In-Reply-To: <472A6D91.1020300@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 02 Nov 2007 10:55:08 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Pavel Emelyanov wrote:
>> The "fix" I mention is just returning -EINVAL in case user orders 
>> CLONE_NEWPIDS
> 
> That is the "fix" you were referring to?  I was hoping you have a sketch
> for a real solution.  If nobody can think of a way to fix this PID

Looks like we misunderstood each other. Can you please elaborate on 
what exactly is broken in pid namespaces?

> namespaces are IMO not something which should go in at all.

We (mainly me and Sukadev) are fixing the issues we are aware of, but 
looks like somebody found something and didn't notify the authors 
about it.

Thanks,
Pavel

> - --
> ➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (GNU/Linux)
> 
> iD8DBQFHKm2R2ijCOnn/RHQRAgjXAKCkU9lcWC9aTR0nG89x47AZO9pVfwCgiaVC
> /Giyp+en+VbtfFyD8D6v4Xk=
> =RnIw
> -----END PGP SIGNATURE-----
> 

