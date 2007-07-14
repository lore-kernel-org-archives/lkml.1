Return-Path: <linux-kernel-owner+w=401wt.eu-S1765488AbXGNVVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765488AbXGNVVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 17:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbXGNVVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 17:21:00 -0400
Received: from mail.screens.ru ([213.234.233.54]:44412 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762472AbXGNVU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 17:20:59 -0400
Date: Sun, 15 Jul 2007 01:21:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
Message-ID: <20070714212102.GA214@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry for being completely off-topic, but

Miklos Szeredi wrote:
>
> SIGKILL won't work on a stopped task.  Neither on a traced task.

Why do you think so? It works in both cases (ptracer can use
PT_TRACE_EXIT, but the task is killed anyway).

> Neither on a zombie (how many newbies are thoroughly confused about
> that ;)

This is true. Unless this zombie is a group leader, and we have other
threads.

Oleg.

