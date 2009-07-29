Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZG2Bve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZG2Bve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZG2Bve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:51:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52820 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZG2Bvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:51:33 -0400
Date: Wed, 29 Jul 2009 03:48:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] do_signal_stop: do not call tracehook_notify_jctl() in
	TASK_STOPPED state
Message-ID: <20090729014820.GA6197@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, this is on top of

	signals-tracehook_notify_jctl-change.patch

and in fact it can be folded into that patch.

Or I can send the unified patch as a replacement, whatever is more
convenient to you.

But, to clarify, the patch above is correct, this one just tries to
improve things, not to fix.

This change doesn't depend on utrace patch.

Oleg.

