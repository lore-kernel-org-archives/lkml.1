Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0BXVQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:16:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757770Ab0BXVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:16:20 -0500
Date: Wed, 24 Feb 2010 13:15:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <teawater@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       gdb-patches ml <gdb-patches@sourceware.org>,
       Michal Marek <mmarek@suse.cz>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 0/2] markup_oops.pl and GDB: Let GDB can handle kernel
 oops stack message
Message-Id: <20100224131545.951db05e.akpm@linux-foundation.org>
In-Reply-To: <4B829750.90107@gmail.com>
References: <4B829750.90107@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010 22:40:16 +0800 Hui Zhu <teawater@gmail.com> wrote:

> So I make a patch for markup_oops.pl to make it can convert the oops
> message to GDB command.
> And make a patch for GDB to add a new target empty which level is same
> with corelow target. It can save the memory and reg operation command's
> value and send it to GDB as the inferior's value. Then GDB can parse the
> oops message directly.

How useful is the kernel patch when one is using an unpatched gdb?
