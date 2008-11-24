Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYKXJEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYKXJEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKXJEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:04:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51666 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYKXJEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:04:23 -0500
Date: Mon, 24 Nov 2008 10:04:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] __used is needed for function referenced only from
	inline asm
Message-ID: <20081124090403.GA25218@elte.hu>
References: <1227514662-10848-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227514662-10848-1-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> According to the gcc manual, the 'used' attribute should be applied to
> functions referenced only from inline assembly.
> This fixes a build failure with llvm-gcc-4.2, which deleted
> __mutex_lock_slowpath, __mutex_unlock_slowpath.
> 
> Signed-off-by: Török Edwin <edwintorok@gmail.com>
> ---
>  kernel/mutex.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

quite sad - it's gcc inline assembly after all - applied to 
tip/core/locking (for v2.6.29). Should this get into v2.6.28 too?

	Ingo
