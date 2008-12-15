Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYLOVoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYLOVoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYLOVoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:44:38 -0500
Received: from static-62-123-141-83.atlanet.it ([62.123.141.83]:54572 "EHLO
	fourier.campana.vi.it" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbYLOVoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:44:37 -0500
Message-ID: <4946DE5C.8060504@dei.unipd.it>
Date: Mon, 15 Dec 2008 22:46:52 +0000
From: Ottavio Campana <ottavio.campana@dei.unipd.it>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, error27@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: Oops when trying to create more than 16000 timers
References: <49468024.1020700@dei.unipd.it>	 <84144f020812150845g10a1ce26ke2844ab495d2591b@mail.gmail.com>	 <4946CEF1.6060405@dei.unipd.it> <84144f020812151337r79268169xf77f2e6f547a51e5@mail.gmail.com>
In-Reply-To: <84144f020812151337r79268169xf77f2e6f547a51e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> I think you're simply hitting RLIMIT_SIGPENDING and then tripping over
> a bug in alloc_posix_timer() that's fixed by commit
> aa94fbd5ccd840c8ab26d02439ec799b03a72547 ("fix error-path NULL deref
> in alloc_posix_timer()") in 2.6.28-rc8.
> 
> Dan, can you please send your patch to the -stable queue as well?

Pekka, can this RLIMIT_SIGPENDING be modified? For my application, I
will need 60k timers.

Thanks,

Ottavio
