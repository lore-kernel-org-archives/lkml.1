Return-Path: <linux-kernel-owner+w=401wt.eu-S1946227AbXBIIlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946227AbXBIIlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 03:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946190AbXBIIlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 03:41:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbXBIIlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 03:41:05 -0500
Date: Fri, 9 Feb 2007 00:41:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-Id: <20070209004101.3e4a88fc.akpm@linux-foundation.org>
In-Reply-To: <20070208105437.26443.35653.sendpatchset@linux.site>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Feb 2007 14:07:15 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:

> So I have finally finished a first slightly-working draft of my new aops
> op (perform_write) proposal. I would be interested to hear comments about
> it.  Most of my issues and concerns are in the patch headers themselves,
> so reply to them.
> 
> The patches are against my latest buffered-write-fix patchset.

What happened with Linus's proposal to instantiate the page as pinned,
non-uptodate, unlocked and in pagecache while we poke the user address?
