Return-Path: <linux-kernel-owner+w=401wt.eu-S1031331AbXD2TtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031331AbXD2TtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031332AbXD2TtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:49:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031331AbXD2TtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:49:01 -0400
Date: Sun, 29 Apr 2007 12:48:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dan Kruchinin" <dubalom@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2
Message-Id: <20070429124831.a7a78c78.akpm@linux-foundation.org>
In-Reply-To: <a8f16e2b0704291219k4c26ca3cj6c16346f22a2fe5d@mail.gmail.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<a8f16e2b0704291219k4c26ca3cj6c16346f22a2fe5d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 23:19:49 +0400 "Dan Kruchinin" <dubalom@gmail.com> wrote:

> I have troubles with rtc on my macbook with mm2:
> ----
> ....
> [126588.386116] rtc: lost some interrupts at 1024Hz.
> [126588.404842] rtc: lost some interrupts at 1024Hz.
> [126588.423566] rtc: lost some interrupts at 1024Hz.
> [126588.442292] rtc: lost some interrupts at 1024Hz.
> [126588.461016] rtc: lost some interrupts at 1024Hz.
> [126588.479741] rtc: lost some interrupts at 1024Hz.
> [126588.498466] rtc: lost some interrupts at 1024Hz.
> [126588.517198] rtc: lost some interrupts at 1024Hz.
> [126588.535923] rtc: lost some interrupts at 1024Hz.
> [126588.554643] rtc: lost some interrupts at 1024Hz.
> ....
> ----
> cat /proc/sys/dev/rtc/max-user-freq
> 64

I don't think there are any rtc changes in -mm which could have caused
this.  Possibly there's something in there which is holding interrupts off
for too long.

> On 2.6.20 there wasn't such problem.

Can you try 2.6.21 please?
