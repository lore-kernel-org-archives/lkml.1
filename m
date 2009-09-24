Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZIXH7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZIXH7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZIXH7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:59:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbZIXH7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:59:13 -0400
Date: Thu, 24 Sep 2009 00:58:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: michal.simek@petalogix.com
Cc: stefani@seibold.net, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       John Williams <john.williams@petalogix.com>
Subject: Re: Microblaze noMMU compilation fault - mm/Makefile
Message-Id: <20090924005824.67b2d1a5.akpm@linux-foundation.org>
In-Reply-To: <4ABB24F2.6070700@petalogix.com>
References: <4ABB24F2.6070700@petalogix.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 09:51:14 +0200 Michal Simek <michal.simek@petalogix.com> wrote:

> Hi Stefani,
> 
> Commit d899bf7b55f503ba7d3d07ed27c3a37e270fa7db break Microblaze noMMU kernel
> 
> There is problem that you setup compilation pagewalk.c which is MMU specific.
> 
> And Andrew add there this comment:
> [akpm@linux-foundation.org: fs/proc/array.c now needs walk_page_range()]
> 
> that mean that the second problem is with compilation of proc/array.c for noMMU.
> 

I don't understand.

Please send us a copy of the compiler error messages.

