Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZCUBlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZCUBlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 21:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZCUBlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 21:41:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZCUBlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 21:41:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: utrace-devel@redhat.com, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/utrace
Subject: [PATCH 0/3] utrace
X-Zippy-Says: My LESLIE GORE record is BROKEN..
Message-Id: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
Date: Fri, 20 Mar 2009 18:39:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

utrace is a new kernel-side API for kernel modules, intended to make it
tractable to work on novel ways to trace and debug user-mode tasks.

These patches apply to the current Linus tree (v2.6.29-rc8-241-g65c2449).
The first two should apply fine on the -tip tree as well, and we will be
glad to rebase the set to whichever tree.  Frank has another version of the
ftrace patch (3/3) that works for -tip.  The utrace patches don't touch
anything unless you set a new kconfig option (still marked EXPERIMENTAL),
and so are quite safe in that regard.

utrace cannot be enabled without CONFIG_HAVE_ARCH_TRACEHOOK and the arch
details it indicates.  If your arch does not have it yet, its maintainers
will have to work on that.  The details are in the comments in arch/Kconfig.

The first patch makes a small update to one of the tracehook.h interfaces
that we needed for utrace.  It moves code a little but does not change any
of the logic in the existing code.

The second patch adds the utrace kernel API (if CONFIG_UTRACE=y is set).
There is no change at all without the config option, and with it there is
no effect on anything at all until a kernel module using the utrace API is
loaded.  There is detailed documentation on the API in DocBook form.

The third patch is an ftrace widget based on utrace, by Frank Eigler.
Frank will follow up on any issues about that patch.


Thanks,
Roland
