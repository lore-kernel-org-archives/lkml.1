Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbZFWVpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbZFWVpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZFWVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:45:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbZFWVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:45:04 -0400
Date: Tue, 23 Jun 2009 14:44:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090623144416.04c34268.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906231423490.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
	<20090623131239.711d9f83.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231355130.17001@makko.or.mcafeemobile.com>
	<20090623142511.c9068655.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231423490.17001@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 14:25:05 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Tue, 23 Jun 2009, Andrew Morton wrote:
> 
> > That isn't for us to decide. Entire syscalls can be disabled in config.
> 
> That is not a well defined separate syscall though. It's a member/feature 
> of the aiocb.

I don't know what this means, really.

AIO eventfd support is a relatively recently added enhancement to AIO,
is it not?  Applications which continue to use the pre-May07 AIO
features will continue to work as before (they darn well better).  So
for such applications, AIO=y/EVENTFD=n kernels are usable and useful,
and eliminating this option is a loss?

Either way, I believe that this change should be unbundled from the
unrelated KVM one so we can handle it separately.
