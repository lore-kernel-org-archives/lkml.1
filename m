Return-Path: <linux-kernel-owner+w=401wt.eu-S1161412AbXBZXq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161412AbXBZXq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161415AbXBZXq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:46:29 -0500
Received: from ozlabs.org ([203.10.76.45]:56313 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161410AbXBZXq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:46:28 -0500
Subject: Re: [PATCH] ____call_usermodehelper: don't flush_signals()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070226215330.GA403@tv-sign.ru>
References: <20070226215330.GA403@tv-sign.ru>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 10:45:36 +1100
Message-Id: <1172533536.13541.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 00:53 +0300, Oleg Nesterov wrote:
> ____call_usermodehelper() has no reason for flush_signals(). It is a fresh
> forked process which is going to exec a user-space application or exit on
> failure.

And the flush_signal_handlers() call?

Your patch looks correct; this code was presumably lying around from
before someone (I?) adapted this code to use kthread.

Thanks,
Rusty.


