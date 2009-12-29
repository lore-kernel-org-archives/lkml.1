Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZL2MMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZL2MMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZL2MMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:12:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZL2MMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:12:45 -0500
Subject: Re: [tip:sched/urgent] sched: might_sleep(): Make file parameter
 const char *
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, simon.kagstrom@netinsight.net, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-d894837f23f491aa7ed167aae767fc07cfe6e6e6@git.kernel.org>
References: <20091223110818.442d848e@marrow.netinsight.se>
	 <tip-d894837f23f491aa7ed167aae767fc07cfe6e6e6@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 13:11:48 +0100
Message-ID: <1262088708.7135.133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 10:10 +0000, tip-bot for Simon Kagstrom wrote:

> Fixes a warning when building with g++:

However did you manage to build stuff with g++? The kernel very
frequently uses C++ keywords for other things.

