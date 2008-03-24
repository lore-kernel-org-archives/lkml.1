Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYCXWae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYCXWae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbYCXWa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:30:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbYCXWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:30:26 -0400
Date: Mon, 24 Mar 2008 15:29:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: ebiederm@xmission.com, xemul@openvz.org, pavel@ucw.cz, sds@tycho.nsa.gov,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-Id: <20080324152906.dee7b272.akpm@linux-foundation.org>
In-Reply-To: <20080323135110.GA294@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2008 16:51:10 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Ptracing of /sbin/init is not allowed. Of course, this is dangerous, but may
> be useful. Introduce the kernel boot parameter to allow this, so that we can't
> surprise some special/secured systems.

I dunno, is this really needed?  If root wants to screw up his kernel then
he is free to do so.

And if we *really* want an extra foot-protector for this, it could be a
runtime /proc/sys/kernel/root-can-shoot-inits-foot rather than a boot-time
option?

