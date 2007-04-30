Return-Path: <linux-kernel-owner+w=401wt.eu-S1423501AbXD3SF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423501AbXD3SF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423480AbXD3SFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:05:55 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423512AbXD3SFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:05:14 -0400
Date: Mon, 30 Apr 2007 11:05:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1: many processes end up in D state
Message-Id: <20070430110510.1f559d34.akpm@linux-foundation.org>
In-Reply-To: <46360DA7.6040003@gmail.com>
References: <46360DA7.6040003@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 17:39:19 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> I have a problem with higher disk loads (e.g. running git-log or yum update).
> Many processes end up in D state and system is unusable -- I'm not able to run
> anything but smooth mouse moving when this happens.
> 
> If I wait for a 20-30sec it becomes usable. This happens in 2.6.21-rc7-mm2 and
> also in 2007-04-28-05-06 broken-out snapshot. I think 2.6.21-rc6-mm1 worked
> fine, but I'm uncertain. If it is important, let me know to re-test.
> 

It is important, but I doubt if retesting 2.6.21-rc6-mm1 will clarify
things a lot.

Could you try switching to a different IO scheduler please?  Anticipatory
would suit.

Please keep a close eye on mainline, too.  Wait for it to appear there :(

