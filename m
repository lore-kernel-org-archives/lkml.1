Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649Ab0ALOXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0ALOXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954Ab0ALOXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:23:49 -0500
Received: from science.horizon.com ([71.41.210.146]:40994 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752943Ab0ALOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:23:48 -0500
Date: 12 Jan 2010 08:57:01 -0500
Message-ID: <20100112135701.558.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at fs/notify/inotify/inotify_fsnotify.c:129
Cc: linux@horizon.com
In-Reply-To: <20100108051219.3498.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is after almost 12 days of uptime, so it's not exactly rapidly
> repeatable.

I spoke to soon.  It appears to be often (but not always) triggered by
the Debian post-install script for udev.  That's a bit of a complex
script, and I haven't figured out where yet.

Interestingly, installing the same package (udev_150-1_i386.deb) on
a 32-bit uniprocessor did not trigger the warning.
