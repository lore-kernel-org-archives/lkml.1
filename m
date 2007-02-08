Return-Path: <linux-kernel-owner+w=401wt.eu-S1161314AbXBHIYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161314AbXBHIYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161488AbXBHIYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:24:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33060 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161314AbXBHIYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:24:40 -0500
Date: Thu, 8 Feb 2007 00:24:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [BUG][PATCH] fix mempolcy's check on a system with
 memory-less-node take2
Message-Id: <20070208002428.1b7aa485.akpm@linux-foundation.org>
In-Reply-To: <200702080919.16879.ak@suse.de>
References: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com>
	<200702080903.46242.ak@suse.de>
	<20070208000857.7296b94b.akpm@linux-foundation.org>
	<200702080919.16879.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 09:19:16 +0100 Andi Kleen <ak@suse.de> wrote:

> The reason we present nodes to user space is that we can tell the user
> where the memory is. You seem to try to promote it to some abstract entity
> beyond that, but that doesn't seem particularly fruitful to me. I think
> I prefer "down to earth" memory nodes.

Who said a node is all about memory?

A node is (often) a circuit board, with an edge connector, containing some,
all or even none of a) CPUs, b) memory and c) IO devices.

That is how a kernel should model and treat it, surely?  That's reality.
