Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXLRAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXLRAQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761254AbXLRAQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:16:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757442AbXLRAQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:16:03 -0500
Date: Mon, 17 Dec 2007 16:15:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core and documentation fixes for 2.6.24-rc5
Message-Id: <20071217161557.f00dd2c8.akpm@linux-foundation.org>
In-Reply-To: <20071217185654.GC4330@kroah.com>
References: <20071217185654.GC4330@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 10:56:54 -0800
Greg KH <gregkh@suse.de> wrote:

> Here are some driver core documentation and translation updates for
> 2.6.24-rc5.  We also delete the whole tipar.c driver as the driver
> author wants it removed because it is no longer needed anymore at all
> (userspace programs work just fine without it.)
> 
> Most of these have been in the -mm tree for a while.

yeah, but the tipar.c one hasn't and it fails the most trivial of tests.

make[3]: *** No rule to make target `/usr/src/devel/include/linux/ticable.h', needed by `/usr/src/devel/usr/include/linux/ticable.h'.  Stop.

Will fix..
