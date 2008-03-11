Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYCKCSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYCKCSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYCKCSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:18:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYCKCSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:18:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: document CLD_CONTINUED notification mechanics
In-Reply-To: Oleg Nesterov's message of  Monday, 10 March 2008 00:53:38 +0300 <20080309215338.GA2296@tv-sign.ru>
References: <20080309215338.GA2296@tv-sign.ru>
X-Shopping-List: (1) Buy & Break Circumlocutions
   (2) Insolent itinerants
   (3) Arctic Reservations
Message-Id: <20080311021741.A863826F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:17:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A couple of small comments about how CLD_CONTINUED notification works.

I'm always in favor of more good comments.

>  		if (why) {
> +			/* The first thread which returns from finish_stop()

Canonical style is:

			/*
			 * The first thread that returns from finish_stop()


Thanks,
Roland
