Return-Path: <linux-kernel-owner+w=401wt.eu-S936266AbXJQDse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936266AbXJQDse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXJQDsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:48:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbXJQDsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:48:22 -0400
Date: Tue, 16 Oct 2007 20:48:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Fix to "All wake-up devices are disabled after suspend-to disk"
 isn't yet included in mainline
Message-Id: <20071016204802.9036ad96.akpm@linux-foundation.org>
In-Reply-To: <200710170439.30359.maximlevitsky@gmail.com>
References: <200710170439.30359.maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 04:39:30 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> A while ago I asked on LKML about the problem of loosing all wake device capabilities, after a suspend to disk
> (eg: I can't wake the system from keyboard if I suspend to disk and then to ram)
> 
> I was provided with the patch that fixes this problem completely.
> The merge window is open, but I still don't see it in the kernel.
> Due to changes it doesn't anymore apply to latest git.
> 
> Was it missed?

No, it's in Len's git tree.

Len's git-pull request from a few days ago didn't work, perhaps because I
wanted to know if a recent -mm regression had been fixed and that hasn't
been answered yet.  I assume that Len is offline.  Other acpi developers
could presumably have answered that question but for some reason chose not to.

I'm presently holding off 20-odd power management patches due to their
dependency upon an acpi merge...
