Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYCLWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYCLWDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYCLWDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:03:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYCLWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:03:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signals: document CLD_CONTINUED notification mechanics
In-Reply-To: Oleg Nesterov's message of  Wednesday, 12 March 2008 15:33:29 +0300 <20080312123329.GA13481@tv-sign.ru>
References: <20080312123329.GA13481@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080312220213.396DA26F992@magilla.localdomain>
Date: Wed, 12 Mar 2008 15:02:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A couple of small comments about how CLD_CONTINUED notification works.

A worthy addition.  I would make the get_signal_to_deliver comment say a
little more.  In particular, it's kind of nonobvious that though this
happens at the beginning of the function, the importance of its placement
is really that it will always be run (via the relock: loop) just after any
wake-up from having been in TASK_STOPPED.


Thanks,
Roland
