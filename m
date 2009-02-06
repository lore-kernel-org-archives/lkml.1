Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZBFIzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZBFIzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZBFIzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:55:43 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:36882 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZBFIzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:55:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dU85oT67W9Ljz2g/4uGOcHrZllhGW251MvhVCNCEfnz8eB78XD6eNVEICxV+B2GZA3
         kzLB/8c0/TmD4WxJFUsz7ePzKV1LsXctUDsks44VKq5PiFzs7amQKiETwQcvdf9YxZWv
         zTY9hcK2uzXC9yAJ1tSHKAA2FTnaE9ngazA38=
MIME-Version: 1.0
In-Reply-To: <20090206030543.GB8560@Krystal>
References: <20090206030543.GB8560@Krystal>
Date: Fri, 6 Feb 2009 09:55:38 +0100
Message-ID: <36ca99e90902060055g67e53ae5k938a4e94c4637885@mail.gmail.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, ltt-dev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 04:05, Mathieu Desnoyers
<compudj@krystal.dyndns.org> wrote:
> Hi Paul,
>
> I figured out I needed some userspace RCU for the userspace tracing part
> of LTTng (for quick read access to the control variables) to trace
> userspace pthread applications. So I've done a quick-and-dirty userspace
> RCU implementation.
>
> It works so far, but I have not gone through any formal verification
> phase. It seems to work on paper, and the tests are also OK (so far),
> but I offer no guarantee for this 300-lines-ish 1-day hack. :-) If you
> want to comment on it, it would be welcome. It's a userland-only
> library. It's also currently x86-only, but only a few basic definitions
> must be adapted in urcu.h to port it.
>
> Here is the link to my git tree :
>
> git://lttng.org/userspace-rcu.git
>
> http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=summary
>
Really interesting, thanks.

But you should use pthread_equal() for you equality test of pthread_t.

Regards,
Bert

> Thanks,
>
> Mathieu
