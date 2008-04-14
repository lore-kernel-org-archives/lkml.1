Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYDNMAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYDNMAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYDNMAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:00:37 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:58825 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbYDNMAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:00:37 -0400
Date: Mon, 14 Apr 2008 13:59:40 +0200 (CEST)
From: Erik Bosman <ejbosman@cs.vu.nl>
X-X-Sender: ebn310@keg.few.vu.nl
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
In-Reply-To: <517f3f820804140357k62b3bff4p555ba6a5b9438c35@mail.gmail.com>
Message-ID: <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
 <517f3f820804140357k62b3bff4p555ba6a5b9438c35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Apr 2008, Michael Kerrisk wrote:

> Erik,
>
> Could you CC me please on kernel-userland API changes.
>
> Also it would be helpful if you could provide a short paragraph
> (plaintext is fine) that describes the new commands and would be
> suitable for inclusion in the prctl.2 (
> http://www.kernel.org/doc/man-pages/online/pages/man2/prctl.2.html )
> man page -- would that be possible?
>
> Cheers,
>
> Michael
>

.TP
.B PR_SET_TSC
(Since Linux 2.6.??, only on x86)
Set the state of the flag determining whether the timestamp counter
can be read by the process. Pass
\fBPR_TSC_ENABLE\fP to \fIarg2\fP to allow it to be read, or
\fBPR_TSC_SIGSEGV\fP to generate a \fBSIGSEGV\fP when the process tries
to read the timestamp counter.
.TP
.B PR_GET_TSC
(Since Linux 2.6.??, only on x86)
Get the state of the flag determining whether the timestamp counter
can be read from \fIarg2\fP.

This is what I would say. I hope it's clear.

Erik
