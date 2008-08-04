Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbYHDW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbYHDW06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYHDW0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:26:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbYHDW0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:26:12 -0400
Date: Mon, 4 Aug 2008 15:25:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: prasad@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, hch@infradead.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 0/2] Renaming 'trace' to 'relay' and enhancements to
 'relay'
Message-Id: <20080804152532.9367abff.akpm@linux-foundation.org>
In-Reply-To: <20080804040439.GA6415@in.ibm.com>
References: <20080804040439.GA6415@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 09:34:39 +0530
"K.Prasad" <prasad@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 	Please find the patches that enhance the 'trace' infrastructure
> (available in the -mm tree) and which introduce two new APIs
> relay_dump() and relay_printk().
> 
> These patches were submitted earlier as enhancements to trace, but were
> renamed and merged with 'relay' based on your suggestion
> (http://lkml.org/lkml/2008/5/28/207).
> 
> The patches apply on 2.6.27-rc1-mm1 and have been tested on an x86
> machine. Kindly accept them.
> 

I'm a bit perplexed by these trace patches
(http://userweb.kernel.org/~akpm/mmotm/broken-out/trace-code-and-documentation.patch).
 Is it useful?  Will it be useful?  Has anyone expressed
interest/intent to use it, etc?  I haven't heard much noise about it
and I'm struggling to justify merging it.

Also, it's starting to look somewhat similar to ftrace, which also
provides sort of high-bandwidth per-cpu channels into userspace for
tracing purposes.
