Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZB1F2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZB1F2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZB1F21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:28:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbZB1F20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:28:26 -0500
Date: Fri, 27 Feb 2009 21:28:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-Id: <20090227212812.26d02f34.akpm@linux-foundation.org>
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 17:59:06 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This series implements the core parts of Xen dom0 support; that is, just
> enough to get the kernel started when booted by Xen as a dom0 kernel.

And what other patches can we expect to see to complete the xen dom0
support?


and..

I hate to be the one to say it, but we should sit down and work out
whether it is justifiable to merge any of this into Linux.  I think
it's still the case that the Xen technology is the "old" way and that
the world is moving off in the "new" direction, KVM?

In three years time, will we regret having merged this?
