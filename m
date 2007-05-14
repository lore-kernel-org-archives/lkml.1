Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbXENUO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbXENUO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXENUOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:14:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42842 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbXENUOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:14:14 -0400
Date: Mon, 14 May 2007 22:13:57 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tracking down disk spinups.
In-Reply-To: <20070514185734.GM27604@redhat.com>
Message-ID: <Pine.LNX.4.61.0705142213070.9570@yvahk01.tjqt.qr>
References: <20070514185734.GM27604@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 14:57, Dave Jones wrote:
>
>I was curious why my firewall box never spins down its disk.
>Given it rarely writes stuff to logs, it's odd that it always
>seems to have something to write out.
>killing syslogd, and enabling /proc/sys/vm/block_dump
>gets me a periodic spew in /proc/kmsg like..

Perhaps it would help if you use `fuser` to see who's got
open files for read and/or write, then strace all processes
and see who does reads/writes?


	Jan
-- 
