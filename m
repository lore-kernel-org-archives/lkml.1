Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbZFLNoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbZFLNoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765789AbZFLNee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:34:34 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:53137 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765828AbZFLNed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g8vAYznClh/mfp3pKVTCLA+MPrCumSR1VLSP77Wt7yux+u5AzuyR5LOdjvaZ6Z0gHG
         kWHcz6tTX5C5VKdkHmbN2bYC85jomnqIAo950J0vZ/QUQPV/6fH1R0qDPILeGVT77isW
         gUF+eJC346Z6K+9vftKiRKvFhXz34xuETnsos=
MIME-Version: 1.0
In-Reply-To: <20090612123152.GE31845@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<20090612120507.GH16044@elte.hu> <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com> 
	<20090612121757.GD31845@elte.hu> <8bd0f97a0906120522v51ae0151i48d5f6846ddcff10@mail.gmail.com> 
	<20090612123152.GE31845@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 09:34:15 -0400
Message-ID: <8bd0f97a0906120634o1f25d713v61e01de6ed47f936@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 08:31, Ingo Molnar wrote:
> That way say build breakages or runtime failures due to perfcounters
> only become possible on an architecture if the architecture
> maintainer has hooked up the syscall

also, this syscall approach is not how any other syscall is handled.
a runtime error along the lines of ENOSYS is trivial to diagnosis and
explain.  you get the exact same behavior on supported architectures
running an older kernel or any kernel with the profiling code
disabled, so any userland code should already be sanely handling this.
-mike
