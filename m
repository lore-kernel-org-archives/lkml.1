Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYIVXwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYIVXwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYIVXwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:52:15 -0400
Received: from twin.jikos.cz ([213.151.79.26]:33805 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbYIVXwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:52:14 -0400
Date: Tue, 23 Sep 2008 01:52:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [patch] log fatal signals like SIGSEGV
In-Reply-To: <200809201912.40381.thomas.jarosch@intra2net.com>
Message-ID: <Pine.LNX.4.64.0809230150290.27884@twin.jikos.cz>
References: <200809121502.15264.thomas.jarosch@intra2net.com>
 <200809181210.40336.thomas.jarosch@intra2net.com> <20080918202010.GA5656@joi>
 <200809201912.40381.thomas.jarosch@intra2net.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008, Thomas Jarosch wrote:

> ------------------------------------------------------
> From: Thomas Jarosch <thomas.jarosch@intra2net.com>
> 
> Log signals like SIGSEGV, SIGILL, SIGBUS or SIGFPE to aid tracing
> of obscure problems. Also logs the sender of the signal.
> 
> The log message looks like this:
> "kernel: signal 9 sent to freezed[2634] uid:100,
>  parent init[1] uid:0 by bash[3168] uid:0, parent sshd[3164] uid:0"

BTW be aware that for example x86 arch-specific code does this on its own, 
and therefore with your patch, the information will be duplicated. See 
page fault handler for x86.

-- 
Jiri Kosina
SUSE Labs

