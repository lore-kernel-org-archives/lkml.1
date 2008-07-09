Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYGIUC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYGIUC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbYGIUCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:02:04 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:37791 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYGIUCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:02:01 -0400
To: "john stultz" <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.9: system clocks works normally then speeds up 4x...
References: <87d4lm2792.fsf@old-tantale.fifi.org>
	<1f1b08da0807091255s77033943t2b686ddb537ceaae@mail.gmail.com>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 09 Jul 2008 13:01:31 -0700
In-Reply-To: <1f1b08da0807091255s77033943t2b686ddb537ceaae@mail.gmail.com>
Message-ID: <874p6y25es.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"john stultz" <johnstul@us.ibm.com> writes:

> On Wed, Jul 9, 2008 at 12:21 PM, Philippe Troin <phil@fifi.org> wrote:
> >
> > Symptoms:
> >
> >  The system boots fine. Clock seems to run normally.
> >
> >  Then after a random amount of time (on the current boot, 3 days),
> >  clock starts to be running 2-4x faster (on the current boot, 4x).
> >
> >  I have tried booting with "nohz=off highres=off" but it does not
> >  help.
> 
> Could you provide the output from the following:
>    sudo cat /sys/devices/system/clocksource/clocksource0/*

Sure.

It is:
available: jiffies tsc 
current:   jiffies

> Did this issue occur with 2.6.24 or earlier kernels?

No.  It started with 2.6.25.

Interestingly:

  I've just modified the current clocksource to tsc and the clock went
  back to its normal speed.

  Then I reset the current clocksource to jiffies, and the clock went
  back to its (wrong) 4x speed.

So it looks like the kernel is counting jiffies 4x too fast.

Phil.
