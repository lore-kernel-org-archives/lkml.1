Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYJGUWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYJGUWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYJGUWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:22:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYJGUWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:22:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: mtk.manpages@gmail.com
X-Fcc: ~/Mail/linus
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall
In-Reply-To: Michael Kerrisk's message of  Tuesday, 7 October 2008 15:49:00 +0200 <cfd18e0f0810070649l391978f9v345a5591728bbf41@mail.gmail.com>
References: <20080930194445.978351700@linutronix.de>
	<cfd18e0f0810070649l391978f9v345a5591728bbf41@mail.gmail.com>
X-Windows: the art of incompetence.
Message-Id: <20081007202135.15982154271@magilla.localdomain>
Date: Tue,  7 Oct 2008 13:21:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You need .sa_flags = SA_SIGINFO.


Thanks,
Roland
