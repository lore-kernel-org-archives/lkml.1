Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbYBWIZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbYBWIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbYBWIJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:48 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765811AbYBWIJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:34 -0500
Date: Sat, 23 Feb 2008 00:04:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, zippel@linux-m68k.org, schwab@suse.de,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values
 to do_div() [try #3]
Message-Id: <20080223000455.a0f543e1.akpm@linux-foundation.org>
In-Reply-To: <20080221165035.16571.67531.stgit@warthog.procyon.org.uk>
References: <20080221165035.16571.67531.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 16:50:35 +0000 David Howells <dhowells@redhat.com> wrote:

> From: David Howells <dhowells@redhat.com>
> 
> The kernel NTP code shouldn't hand 64-bit *signed* values to do_div().  Make it
> instead hand 64-bit unsigned values.  This gets rid of a couple of warnings.

On certain architectures.  It would have bene nice to mention what those
architectures are, and to quote the warnings.  Next time, please ;)

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  kernel/time/ntp.c |   12 +++++++-----

Thomas, do you consider ntp to fall under git-hrt?
