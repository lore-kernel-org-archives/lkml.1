Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZIWTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZIWTzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZIWTzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:55:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZIWTzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:39 -0400
Date: Wed, 23 Sep 2009 15:55:40 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 09/13] parisc: Remove useless altinstructions code
	copied from x86.
Message-ID: <20090923195540.GI11961@bombadil.infradead.org>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com> <1253629347-23119-10-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253629347-23119-10-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 10:22:23AM -0400, Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Helge Deller <deller@gmx.de>
> Cc: linux-parisc@vger.kernel.org
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Heh, I had a patch to use this, but I guess I never finished it, (to nop
out some cache flushes and syncs on coherent architectures in the iommu
code.) I'll add a hunk to bring it back if/when I ever submit that
change.

cheers, Kyle
