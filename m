Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbXKFGZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbXKFGZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXKFGZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:25:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbXKFGZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:25:38 -0500
Date: Mon, 5 Nov 2007 22:25:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] kobject and kset core changes and cleanups
Message-Id: <20071105222532.2dc1f4a5.akpm@linux-foundation.org>
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007 16:57:58 -0700 Greg KH <gregkh@suse.de> wrote:

> So, I go on vacation for a week or so and come back to an overflowing
> inbox.  Instead of trying to wade through all of that, I decide to
> finish up the work Kay and I had started on cleaning up the kset core
> code.

Now I'm rather screwed.  I still need to revert
gregkh-driver-block-device.patch so that the G5 will boot, but doing that
restores the decl_subsys(block, &block_uevent_ops) in genhd.c, and that no
longer compiles.

