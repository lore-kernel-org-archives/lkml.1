Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbXGRIHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbXGRIHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXGRIHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:07:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbXGRIHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:07:21 -0400
Date: Wed, 18 Jul 2007 01:07:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
Message-Id: <20070718010700.1ca7fd9f.akpm@linux-foundation.org>
In-Reply-To: <20070718075648.GA4235@linux.vnet.ibm.com>
References: <20070718075648.GA4235@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 13:26:48 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> I was running kernbench on top of 2.6.22-rc6-mm1 and I got a Hangcheck
> alert (This is when kernbench reached make -j).

hm, never had a report of that before.  It's the first time I've seen
hangcheck produce anything useful, frankly.

Was the softlockup detector not enabled?

> Also make -j is hanging.

Please try to capture the full sysrq-T output when it is hung.

