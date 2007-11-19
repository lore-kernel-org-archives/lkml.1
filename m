Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbXKSTDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbXKSTDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXKSTDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:03:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59866 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbXKSTDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:03:37 -0500
Date: Mon, 19 Nov 2007 20:02:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jeremy@goop.org
Subject: Re: [patch 07/26] fix the softlockup watchdog to actually work
Message-ID: <20071119190242.GB12650@elte.hu>
References: <20071119181438.617190424@mini.kroah.org> <20071119181846.GH15425@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119181846.GH15425@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Kroah-Hartman <gregkh@suse.de> wrote:

> 2.6.22-stable review patch.  If anyone has any objections, please let 
> us know.

we shouldnt do this for 2.6.22 - it has no proper cpu_clock() facility 
like .23 or .24. So lets leave this alone.

	Ingo
