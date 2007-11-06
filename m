Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXKFI1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXKFI1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXKFI1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:27:32 -0500
Received: from sacred.ru ([62.205.161.221]:59289 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXKFI1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:27:31 -0500
Message-ID: <47301C7F.3080705@openvz.org>
Date: Tue, 06 Nov 2007 10:49:19 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>, Theodore Tso <tytso@mit.edu>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>	<4729E7E4.8070208@openvz.org>	<4729E936.4040400@redhat.com>	<4729EB3C.9050102@openvz.org>	<472A6D91.1020300@redhat.com>	<472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com> <472B327E.2060006@openvz.org> <472B4378.80809@redhat.com> <472B4937.1050106@openvz.org> <472BFA4B.9040506@redhat.com>
In-Reply-To: <472BFA4B.9040506@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 06 Nov 2007 11:24:58 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Pavel Emelyanov wrote:
>> Having access to the same IPCs in different pid namespaces won't work.
>> Having access to the same filesystem in different IPC namespaces won't work.
>> Having access to the same UID namespace in different VFS namespaces won't work.
>> Having access to the same <any> namespace in different <many others> namespace
>>  wont' work.
>> [...]
> 
> 
> Then explicitly prevent the cases which cannot work in the clone()
> calls.  Yes, giving people rope to shoot themselves is a Unix tradition
> but it's so unnecessary in this case and will only cause support
> problems for innocent people.

:)

> I bet the result will be that if you have a separate PID namespace you
> need to enforce every other namespace as well.  There are simply too
> many dependencies.

I think, that Ted's proposal (about the "namespaces compatibility matrix") is 
better. I'd prefer knowing of what can stop working in case I do something
rather that forcedly having my hands off this.

Thanks,
Pavel
