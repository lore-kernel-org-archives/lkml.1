Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYGKTg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYGKTg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYGKTgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:36:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54022 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYGKTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:36:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Hw/liQ0hr/rl6QwOMF+fRHjE0Y7VCa3Znn8Kdf+vrcJpNjs0Nf6tlRlKsXJ5hBrjn
	+m6uGD6V6rrUX6ge9i4rQ==
Message-ID: <6599ad830807111236t2bc9aa02ned59dcc58f14b1bf@mail.gmail.com>
Date: Fri, 11 Jul 2008 12:36:41 -0700
From: "Paul Menage" <menage@google.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Paul Jackson" <pj@sgi.com>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 12:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> The result of having CPUSETS enabled as above is a 100% reproducible
> BUG on the very first cpu hot-unplug:
>
> ------------[ cut here ]------------
> kernel BUG at xxx/linux-2.6/kernel/sched.c:5859!

That doesn't quite match up with any BUG in 2.6.26-rc9 - what tree is
this last crash based on?

>
> Also, this is on the latest linux-2.6.git! Since we're so close to
> release, maybe cpusets should simply be marked BROKEN for now? (Unless
> we can fix it, of course. The alternative is to apply Miao Xie's
> workaround patch temporarily.)

If we were going to mark anything as broken, wouldn't cpu-hotplug be
the more appropriate victim? I suspect that there are more systems
using cpusets in production environments than using cpu hotplug. But
as you say, fixing it sounds better.

Paul
