Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbYAKXpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbYAKXpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYAKXpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:45:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762901AbYAKXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:45:19 -0500
Date: Fri, 11 Jan 2008 15:45:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS v10: Correct do_signal to fix oops and clean up
 signal handling in general.
Message-Id: <20080111154513.43c0d414.akpm@linux-foundation.org>
In-Reply-To: <20080111185923.GE27482@axis.com>
References: <20080111185923.GE27482@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 19:59:24 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> CRIS v10: Correct do_signal to fix oops and clean up signal handling in general.
> 
> This fixes a kernel panic on boot due to do_signal not being compatible
> with it's callers.
> 

Please sequence-number patches even if they are unrelated.  That will make
emails like this one easier.

1: CRIS v10: Correct do_signal to fix oops and clean up signal handling in general.
2: CRIS: Define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS
3: CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile.
4: CRIS v10: Driver for ds1302 needs to include cris-specific i2c.h

Patches 3 and 4 were missing your signed-off-by:.  I added it.

I queued patches 1, 3 and 4 for 2.6.24 and patch 2 for 2.6.25.  Do you agree?
