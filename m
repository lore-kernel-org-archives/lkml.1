Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYKZQ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYKZQ4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYKZQ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:56:13 -0500
Received: from vena.lwn.net ([206.168.112.25]:37726 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYKZQ4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:56:12 -0500
Date: Wed, 26 Nov 2008 09:56:10 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Document sysfs interface to RTC system wakeup
Message-ID: <20081126095610.13195e15@bike.lwn.net>
In-Reply-To: <20081126161524.GD1983@elf.ucw.cz>
References: <20081126161524.GD1983@elf.ucw.cz>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 17:15:24 +0100
Pavel Machek <pavel@suse.cz> wrote:

> +How to use /sys/class/rtc/rtcX/wakealarm
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +This file takes the seconds since epoch to enable a wake event at the
> +specified time.

More documentation is cool.  In this case, though, I'm left with an
immediate question: *why* am I interested in wakealarm?  Reading
through, I eventually figure out that it can maybe be used to get a
system to start up at some point in the future, maybe.  It seems like
that should be said at the outset.

Also; why do I want to migrate from /proc/acpi/alarm?

jon
