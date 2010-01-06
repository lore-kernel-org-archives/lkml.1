Return-Path: <linux-kernel-owner+w=401wt.eu-S932606Ab0AFSpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab0AFSpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932494Ab0AFSps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:45:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932483Ab0AFSps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:45:48 -0500
Date: Wed, 6 Jan 2010 10:45:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       uclinux-dev@uclinux.org, Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/4] elf_fdpic_core_dump(): fix build break in
 2.6.33-rc1
In-Reply-To: <20100106172333.25862.40963.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.1001061044000.3630@localhost.localdomain>
References: <20100106172317.25862.64950.stgit@warthog.procyon.org.uk> <20100106172333.25862.40963.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jan 2010, David Howells wrote:
>
> From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
> 
> Commit f6151dfea21496d43dbaba32cfcd9c9f404769bc causes ELF-FDPIC to break
> during building, so this patch fixes it together with a correction for the
> printk format.

The comment doesn't match the patch. There's no build breakage fix (the 
actual fix was already merged, and your patch reflects that), there's only 
a printk format "fix" that is actually a de-provement because it splits 
the string across multiple lines.

So a strong NAK to this patch.

		Linus
