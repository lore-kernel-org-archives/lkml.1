Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbYFIVWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbYFIVWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYFIVWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:22:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbYFIVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:22:01 -0400
Date: Mon, 9 Jun 2008 14:21:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Reuther <mreuther@umich.edu>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: Re: 2.6.26-rc2-mm1: modules_install error: 9p.ko ignored, due to
 loop
Message-Id: <20080609142127.ea4c8aab.akpm@linux-foundation.org>
In-Reply-To: <200806081234.53080.mreuther@umich.edu>
References: <200806081234.53080.mreuther@umich.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 12:34:52 -0400
Matt Reuther <mreuther@umich.edu> wrote:

> I compiled and then tried to install the 2.6.26-rc2-mm1, and I got this 
> message. I didn't see this discussed anywhere.
> 
> WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/fs/9p/9p.ko ignored, due to 
> loop
> WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet_fd.ko ignored, 
> due to loop
> WARNING: Loop detected: /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet.ko 
> needs 9pnet_fd.ko which needs 9pnet.ko again!
> WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet.ko ignored, 
> due to loop
> WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet_virtio.ko 
> ignored, due to loop
> 
> My .config is attached.

Thanks.  I was unable to reproduce this with your config in
2.6.26-rc5-mm1.  Perhaps sometime you could check that it is fixed for
you also?

