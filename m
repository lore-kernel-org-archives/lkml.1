Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbXLGOfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbXLGOfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXLGOe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:34:56 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:10477 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbXLGOez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:34:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fAUM0Xh+mBi62vkvyoDhxaMxM4p8ZezlQpZl7KKaEqunXUJtgm0XGLHVD1Umde4tNTtLhgcfSj1PNOitksubzLkaBYOSvizrTFpA0ovpu/ELHzkpppAn9WZPBGcTw6oGNbCNPKba9jjLtlZZ+QiNMjkzbEik9o8asFn2wylCtGQ=
Message-ID: <47595A0A.5000502@gmail.com>
Date: Fri, 07 Dec 2007 15:34:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2007 06:17 AM, Andrew Morton wrote:
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/

>  git-sched.patch

breaks suspend here since -rc3-mm2. More precisely, this one:
softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks

2.6.24-rc4-mm1 minus this one works just fine. Otherwise disks stop, graphics
stops and then it hangs not powering down.

Core 2 Duo, SMP kernel, voluntary preempt, 250 HZ, SLUB, 64 bit.

Ideas?
