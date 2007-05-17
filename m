Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbXEQXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbXEQXsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEQXsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:48:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104AbXEQXsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:48:12 -0400
Date: Thu, 17 May 2007 16:46:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Andree <matthias.andree@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dumping a process's pagetable entries?
Message-Id: <20070517164631.349d45aa.akpm@linux-foundation.org>
In-Reply-To: <20070517091142.GA7441@merlin.emma.line.org>
References: <20070517091142.GA7441@merlin.emma.line.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 11:11:42 +0200
Matthias Andree <matthias.andree@gmx.de> wrote:

> [please remember to Cc: me on your replies]
> 
> Greetings,
> 
> is there an easy way to dump a process's pagetables from outside that
> process?  Tools, /proc or /sys file or syscall that I missed?
> 

/proc/pid/pagemap and /proc/kpagemap (presently in -mm as maps2*.patch)
might be suitable.
