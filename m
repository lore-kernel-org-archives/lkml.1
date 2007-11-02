Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbXKBOf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbXKBOf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbXKBOfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:35:39 -0400
Received: from sacred.ru ([62.205.161.221]:59185 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbXKBOfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:35:37 -0400
Message-ID: <472B327E.2060006@openvz.org>
Date: Fri, 02 Nov 2007 17:21:50 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>	<4729E7E4.8070208@openvz.org>	<4729E936.4040400@redhat.com>	<4729EB3C.9050102@openvz.org>	<472A6D91.1020300@redhat.com>	<472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com>
In-Reply-To: <472B2EBD.7070007@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 02 Nov 2007 17:21:52 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Pavel Emelyanov wrote:
>>> Isn't it this?
>>>
>>> http://lkml.org/lkml/2007/11/1/141
>> That was the initial problem, and I already answered to Ingo about
>> it
> 
> No, look at my old mail which Ingo referenced in that posting.

You pointed only one problem that is not a variation of "how do 
we handle the case when we pass our pid outside the namespace".

This problem with signals is now being resolved at IBM by Sukadev 
and Serge (I put them in Cc), so this is about to be fixed by the
time 2.6.24 releases (I hope).

As far as the "passing the pid outside the namespace" is concerned, 
is my answer "pids should never be used outside the namespace they
came from, otherwise userspace won't work as expected" satisfactory?

So is "everything else", you mentioned, covered with the problems
above?

> - --
> ➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (GNU/Linux)
> 
> iD8DBQFHKy692ijCOnn/RHQRAtYLAJ98EXTGl3HMlCbVXOkL7TJRFfw4DACfcgYI
> HHz5f7TfM05Dps+ruPRiUrU=
> =IjS4
> -----END PGP SIGNATURE-----
> 

