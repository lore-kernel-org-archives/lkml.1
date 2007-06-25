Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbXFYM5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbXFYM5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXFYM5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:57:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1648 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXFYM5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:57:07 -0400
Date: Mon, 25 Jun 2007 17:04:34 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, ak@suse.de, hch@infradead.org,
       devel@openvz.org
Subject: Re: [PATCH -mm 2/2] x86_64: semi-rewrite of PTRACE_PEEKUSR, PTRACE_POKEUSR
Message-ID: <20070625130434.GC6632@localhost.sw.ru>
References: <20070620150844.GC6663@localhost.sw.ru> <20070620214148.51AE34D05DC@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620214148.51AE34D05DC@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 02:41:48PM -0700, Roland McGrath wrote:
> What's the purpose of the change?

Chopping small bits of utrace to mainline.

regset stuff looks reasonable and self-contained enough to start with.
However, regset part in utrace contain quite a few unused things, so
I'm leaving those alone. Their time will come (or won't).

This way we can merge non-racy stuff first and leave core utrace for
later.

