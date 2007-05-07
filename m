Return-Path: <linux-kernel-owner+w=401wt.eu-S966781AbXEGUng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966781AbXEGUng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966517AbXEGUnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:43:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966772AbXEGUnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:43:31 -0400
Date: Mon, 7 May 2007 13:42:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.21-mm1+hotfix -- Time gets confused during resume from
 suspend (18014554.415987)
Message-Id: <20070507134246.c937cdd7.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0705071213md3a403bk3b4b6686a7e333db@mail.gmail.com>
References: <a44ae5cd0705071213md3a403bk3b4b6686a7e333db@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 12:13:30 -0700
"Miles Lane" <miles.lane@gmail.com> wrote:

> [ 1278.513048] agpgart-intel 0000:00:00.0: LATE suspend
> [ 1278.513791]  hwsleep-0323 [03] enter_sleep_state     : Entering
> sleep state [S3]
> [18014554.415987] Intel machine check architecture supported.
> [18014554.416010] Intel machine check reporting enabled on CPU#0.
> [18014554.416050] Back to C!
> [ 1281.221504] agpgart-intel 0000:00:00.0: EARLY resume
> [ 1281.221508] PCI: Calling quirk c01cbfe6 for 0000:00:00.0
> [ 1281.221510] pci 0000:00:00.1: EARLY resume
> [ 1281.221513] PCI: Calling quirk c01cbfe6 for 0000:00:00.1

I think Andi had a suspend/resume handler which would prevent this,
but it got temporarily removed and will soon be coming back?
