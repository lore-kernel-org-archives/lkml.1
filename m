Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXAVTTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXAVTTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXAVTTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:19:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbXAVTTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:19:52 -0500
Date: Mon, 22 Jan 2007 20:18:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -rt] make spin_unlock to slab_spin_unlock
Message-ID: <20070122191800.GA12911@elte.hu>
References: <Pine.LNX.4.58.0701221407060.24244@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0701221407060.24244@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> I hit this bug on one of my work test machines. This bug is probably 
> what caused my laptop to crash ever so often too, but since I don't 
> have a serial or other debug output, my laptop never showed what was 
> wrong.

ah, nice one! Thanks, applied,

	Ingo
