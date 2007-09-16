Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbXIPKSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbXIPKSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 06:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXIPKS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 06:18:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbXIPKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 06:18:26 -0400
Date: Sun, 16 Sep 2007 03:18:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: "Andi Kleen" <ak@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: constify stacktrace_ops
Message-Id: <20070916031820.fc85d43d.akpm@linux-foundation.org>
In-Reply-To: <46E55C79.76E4.0078.0@novell.com>
References: <46E55C79.76E4.0078.0@novell.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 14:02:17 +0100 "Jan Beulich" <jbeulich@novell.com> wrote:

> .. as they're never written to.

arch/i386/kernel/traps.c: In function 'dump_trace':
arch/i386/kernel/traps.c:197: warning: initialization discards qualifiers from pointer target type

Due to

                struct ops_and_data oad = { .ops = ops, .data = data };

messy to fix.
