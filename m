Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbYDNLnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbYDNLnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYDNLnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:43:16 -0400
Received: from saeurebad.de ([85.214.36.134]:52786 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYDNLnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:43:16 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Andrew <nick@nick-andrew.net>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Subject: Re: [PATCH 2/2] printk: Remember the message level for multi-line output
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net>
	<20080413122735.31769.17716.stgit@marcab.local.tull.net>
	<20080414080351.GL16163@elte.hu> <20080414101200.GH29599@tull.net>
	<20080414102634.GA20649@elte.hu>
Date: Mon, 14 Apr 2008 13:43:12 +0200
In-Reply-To: <20080414102634.GA20649@elte.hu> (Ingo Molnar's message of "Mon,
	14 Apr 2008 12:26:34 +0200")
Message-ID: <87iqyk7jcf.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar <mingo@elte.hu> writes:

> btw., we could also start emitting debug warnings that the printk is not 
> conform. Something like:
>
>   "INFO: the previous printk was done without a KERN_ annotation"

Urgh, that would become very noisy.  If, at all, I'd suggest a config
option like CONFIG_DEBUG_PRINTK_USAGE and then add a prefix string to
each printk()ed line missing a severity level.

printk("foo\n");
=> "[FIX PRINTK] foo"

	Hannes
