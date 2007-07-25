Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbXGYX7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbXGYX7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXGYX65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:58:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57180 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXGYX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:58:56 -0400
Date: Wed, 25 Jul 2007 16:58:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: masouds@google.com (Masoud Asgharifard Sharbiani)
Cc: Andi Kleen <ak@suse.de>, Kirill Korotaev <dev@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-Id: <20070725165805.1bcd5a02.akpm@linux-foundation.org>
In-Reply-To: <20070725234005.GA11292@google.com>
References: <20070718154759.GA26425@google.com>
	<46A76210.5020903@openvz.org>
	<200707251657.44217.ak@suse.de>
	<20070725140455.cbbc0dde.akpm@linux-foundation.org>
	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
	<20070725162528.7d485ff8.akpm@linux-foundation.org>
	<20070725234005.GA11292@google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 16:40:06 -0700
masouds@google.com (Masoud Asgharifard Sharbiani) wrote:

> > Look: if there's a way in which an unprivileged user can trigger a printk
> > we fix it, end of story.  I don't know why this even slightly
> > controversial.
> > 
> 
> Fair enough. Here it is:

My favourite words.

> ---------------
> Hello,
> This patch makes the i386 behave the same way that x86_64 does when a
> segfault happens. A line gets printed to the kernel log so that tools
> that need to check for failures can behave more uniformly between
> different kernels. Like x86_64, it can be disabled by setting
> debug.show_unhandled_signals sysctl variable to 0 (or by doing
> echo 0 > /proc/sys/debug/show_unhandled_signals)

Do we really need the ratelimiting?  If the admin turns this on then he's
presumably prepared for the consequences.

I guess "yes", as people (even distros) are likely to turn this on and
forget about it.

The patch is larger than I expected, ho hum.
