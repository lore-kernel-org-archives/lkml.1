Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYKKK0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYKKK0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYKKK01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:26:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYKKK00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:26:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@lst.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: wierd new config options
In-Reply-To: Christoph Hellwig's message of  Thursday, 23 October 2008 20:18:18 +0200 <20081023181818.GA25430@lst.de>
References: <20081023181818.GA25430@lst.de>
X-Windows: you'd better sit down.
Message-Id: <20081111102615.2D2D61541CA@magilla.localdomain>
Date: Tue, 11 Nov 2008 02:26:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CORE_DUMP_DEFAULT_ELF_HEADERS is similarly odd, it turns something on
> that break old userspace, this really really should be a sysctl to turn
> on instead of a config option.

Both the kconfig help text and the commit's log mention that this is
controlled per-process via /proc/PID/coredump_filter.  The new config
option only changes the boot-time default value to be inherited.


Thanks,
Roland
