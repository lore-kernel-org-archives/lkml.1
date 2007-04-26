Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXDZNa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXDZNa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXDZNa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:30:56 -0400
Received: from mail.screens.ru ([213.234.233.54]:44875 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXDZNaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:30:55 -0400
Date: Thu, 26 Apr 2007 16:36:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm] Move frozen_process() to kernel/power/process.c
Message-ID: <20070426123609.GA1076@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <20070420180208.GA721@tv-sign.ru> <20070423102618.GA25144@in.ibm.com> <200704260044.03975.rjw@sisk.pl> <20070425231638.GH15134@in.ibm.com> <20070425163409.4f8476c4.akpm@linux-foundation.org> <20070426060608.GA12892@in.ibm.com> <20070425231232.302a83f0.akpm@linux-foundation.org> <20070426131155.GE12892@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426131155.GE12892@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Gautham R Shenoy wrote:
> 
> Other than refrigerator, no one else calls frozen_process(). So move it from
> include/linux/freezer.h to kernel/power/process.c.

Could you also remove this

	static inline void frozen_process(struct task_struct *p) { BUG(); }

from freezer.h ?

Oleg.

