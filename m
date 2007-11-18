Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXKRVF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXKRVF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 16:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXKRVFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 16:05:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41764 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbXKRVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:05:49 -0500
Date: Sun, 18 Nov 2007 13:05:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-Id: <20071118130503.7d5ec842.akpm@linux-foundation.org>
In-Reply-To: <200711182038.22055.deller@gmx.de>
References: <200711182038.22055.deller@gmx.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 20:38:21 +0100 Helge Deller <deller@gmx.de> wrote:

> Title: Add time-based RFC 4122 UUID generator
> 
> The current Linux kernel currently contains the generate_random_uuid() 
> function, which creates - based on RFC 4122 - truly random UUIDs and 
> provides them to userspace through /proc/sys/kernel/random/boot_id and 
> /proc/sys/kernel/random/uuid.
> 
> This patch additionally adds the "Time-based UUID" variant of RFC 4122, 
> with which userspace applications can easily get real unique time-based 
> UUIDs through /proc/sys/kernel/random/uuid_time.
> A new /proc/sys/kernel/random/uuid_time_clockseq sysfs entry is available,
> so that the clock_seq value can be retained across system bootups (which
> is required by RFC 4122).
> 
> The attached implementation uses getnstimeofday() to get very fine-grained
> granularity. This helps, so that userspace tools can get a lot more UUIDs 
> (if needed) per time than before.
> A mutex takes care of the proper locking against a mistaken double creation 
> of UUIDs for simultanious running processes.

Who will use this feature, and for what?

(In fact, who uses the existing UUID generators, and for what?)

Thanks.
