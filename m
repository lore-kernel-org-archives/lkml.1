Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYBAPLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYBAPLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYBAPLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:11:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:7636 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYBAPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:11:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GlfklOYuIfsLDINUuhaSXVebaXZv1aiUa4nYgoRRy7XMlROjQe5IhE06Y/rkulZ++hQRUrEq9Z/gkCemaTTyOa+TmbpJ7QlVX+wN556G1RwhyOvddLebE8snJrj8NglM0sgpIxHpFKinZH52pSPp42TV4CgOJFk+muPyfkX6B8Q=
Message-ID: <b647ffbd0802010711q744f5023mdbfccd9540556b70@mail.gmail.com>
Date: Fri, 1 Feb 2008 16:11:43 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1201867497.32654.49.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801272229.48955.rjw@sisk.pl> <200801280226.22013.rjw@sisk.pl>
	 <1201795128.32654.22.camel@lappy> <200801312154.33754.rjw@sisk.pl>
	 <1201867497.32654.49.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2008, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> ---
>  - restore the old wakeup mechanism

and how does it change behavior, logically-wise?

do we somehow miss a 'wake-up' from kthread_stop() so that its caller
gets blocked until watchdog's msleep_interruptible(10000) timeouts? On
average, it would take +-5 sec. and might explain the first
observation of Ravael -- "...adds a 5 - 10 sec delay..." (although,
lately he reported up to +30 sec. delays).

(/me goint to also try reproducing it later today)

> [ ... ]

-- 
Best regards,
Dmitry Adamushko
