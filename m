Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbXEJM0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbXEJM0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXEJM0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:26:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:49824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbXEJM0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:26:41 -0400
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch 1/4] KMON - kmon device/instrumentation ...
References: <send-serie.davidel@xmailserver.org.27461.1178495355.1>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 May 2007 15:23:50 +0200
In-Reply-To: <send-serie.davidel@xmailserver.org.27461.1178495355.1>
Message-ID: <p73k5vgg6c9.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> This patch serie introduces a way to log high frequency/volume data
> out of the kernel. Logging scheduler operations for example, with
> loads that generate tenths of thousands of context switches per second
> (possibly from multiple CPUs), can overload the kernel printk. Also,
> logging in binary form helps in reducing the size of the logged data
> that is tranfered from kernel to userspace. The kmon logger uses per
> CPU buffers (rings) that are flushed at a given frequency to all the
> instances of the kmon devices.

Sounds like you reinvented relayfs? (and ktrace before that)

-Andi
