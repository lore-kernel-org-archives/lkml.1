Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYEEGbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYEEGbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYEEGbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:31:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58914 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbYEEGbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:31:33 -0400
Date: Mon, 5 May 2008 08:31:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stacktrace: don't crash on invalid stack trace structs
Message-ID: <20080505063117.GA3350@elte.hu>
References: <1209904761.4065.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209904761.4065.19.camel@johannes.berg>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> This patch makes the stacktrace printout code warn when the entries
> pointer is unset rather than crashing when trying to access it in an
> attempt to make it a bit more robust.
> 
> I was saving a stacktrace into an skb and forgot to copy it across skb 
> copies... Not sure if you want this, I have since fixed the code, but 
> it would have been easier had the kernel not crashed in an interrupt.

applied, thanks Johannes.

I agree that such code needs to be more resilient, and resilience is 
mainly driven by observing random incidents as they happen in the field. 
So please keep sending such patches (even if they might seem dubious to 
you at first sight), they do make a lot of sense - and even if a patch 
does not end up getting applied your submission documents the incident.

	Ingo
