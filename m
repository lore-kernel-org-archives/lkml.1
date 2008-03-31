Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYCaTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYCaTF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYCaTFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:05:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:54392 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751586AbYCaTFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:05:16 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19tIgQZ56Rt+jsPENVnd4g1hgm1gKm9SmM8MkKAvn
	KsTQKEBwtaZdxh
Date: Mon, 31 Mar 2008 21:05:10 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
Message-ID: <20080331190509.GA2876@atjola.homenet>
References: <20080330184259.GB21375@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080330184259.GB21375@atjola.homenet>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.03.30 20:42:59 +0200, Björn Steinbrink wrote:
> I can't reproduce the bug on my UP box and currently can't afford
> crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> guess it needs SMP to crash), so while this doesn't show any new
> problems, I can't tell whether it actually fixes anything. Testers
> welcome!

Hm, crap, can't reproduce on my x86_64 SMP box either. Tried with
various preemption models as well as rcu classic and preempt. Johannes,
is there anything "special" in your configuration?

Björn
