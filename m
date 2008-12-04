Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYLDBGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYLDBGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYLDBGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:06:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbYLDBGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:06:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rnalumasu@gmail.com
Subject: Re: do_wait() vs do_notify_parent_cldstop() theoretical race?
In-Reply-To: Oleg Nesterov's message of  Sunday, 23 November 2008 22:55:11 +0100 <20081123215511.GB9097@redhat.com>
References: <200811212015.mALKFMs4019558@imap1.linux-foundation.org>
	<20081123213929.GA9097@redhat.com>
	<20081123215511.GB9097@redhat.com>
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081204010548.90F91FC053@magilla.sf.frob.com>
Date: Wed,  3 Dec 2008 17:05:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess.  There might well be something in there implicitly that's actually
a memory barrier already.  But sounds like that should use set_current_state().


Thanks,
Roland
