Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbYFDKhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbYFDKhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYFDKhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:37:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46575 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbYFDKhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:37:07 -0400
Date: Wed, 4 Jun 2008 12:36:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] Make x86 latest boot with non-discontig boxes
Message-ID: <20080604103637.GA2837@elte.hu>
References: <1212552507-15134-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212552507-15134-1-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> Commit 0596152388e234efebce464355186ad9e16c8cb6 broke my box, since it 
> removes completely the call to memory_present() at e820 setup.
> 
> It seems to be really not needed with discontig memory, but with flat 
> and sparse, I get an early crash. The proposed patch moves the call 
> memory_present() to setup_memory, the one present in setup_32.c.

thanks for tracking it down. Could you check whether the latest 
x86/master tree works fine now?

	Ingo
