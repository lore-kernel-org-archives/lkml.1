Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZKHWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZKHWhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 17:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZKHWhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 17:37:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:40840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZKHWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 17:37:40 -0500
Date: Sun, 8 Nov 2009 14:39:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       jens.axboe@oracle.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-ID: <20091108143908.78dd97a1@infradead.org>
In-Reply-To: <4e5e476b0911081359x32d7a6c4x61ee3af92dc0c8a1@mail.gmail.com>
References: <20090915054259.5282e5ba@infradead.org>
	<4e5e476b0911040139h1f471627la4262a5fa66abab0@mail.gmail.com>
	<20091108124035.23d53197@infradead.org>
	<4e5e476b0911081359x32d7a6c4x61ee3af92dc0c8a1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009 22:59:43 +0100
Corrado Zoccolo <czoccolo@gmail.com> wrote:

> Unfortunately, I have seen polling residency times > 1ms, so it must
> not be so accurate.


hmm I wonder if the timer hardware in use has a much larger
granularity than usecs... 
because that rounding up could cost us dearly.

wonder if we should do some form of "check for timer expiry" as part of
the polling loop.. that'd cut latency way down as well ;)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
