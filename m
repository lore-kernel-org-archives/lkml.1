Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZF3Vl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZF3Vl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZF3VlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:41:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbZF3VlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:41:20 -0400
Date: Tue, 30 Jun 2009 14:41:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Masami Hiramatsu <mhiramat@redhat.com>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration
 dependency
In-Reply-To: <20090630143806.9ab4519d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0906301440280.3605@localhost.localdomain>
References: <20090622210302.4984.82798.stgit@localhost.localdomain> <20090630143806.9ab4519d.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jun 2009, Andrew Morton wrote:
> 
> Still, the end result is significently more complex and fragile than a
> `depends on' would have been.  But I suppose we've done worse.  Oh well.

Couldn't we just limit the selftest to a set of symbols that doesn't 
require the "all" part?

		Linus
