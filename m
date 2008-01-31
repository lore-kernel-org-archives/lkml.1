Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbYAaWTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbYAaWTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbYAaWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:19:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbYAaWTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:19:45 -0500
Date: Thu, 31 Jan 2008 23:19:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
Message-ID: <20080131221935.GA5080@elte.hu>
References: <20080131221436.GA3760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131221436.GA3760@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Jens,
> 
> AS still has some locking issues - see the lockdep warning below that 
> the x86 test-rig just triggered. Config attached. Never saw this one 
> before. Can send more info if needed.

btw., it didnt reproduce after a reboot, so it seems like a sporadic 
condition.

	Ingo
