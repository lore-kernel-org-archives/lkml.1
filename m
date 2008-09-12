Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbYILIXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbYILIXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 04:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYILIXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 04:23:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYILIXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 04:23:03 -0400
Date: Fri, 12 Sep 2008 04:23:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: linux-arch@vger.kernel.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
Message-ID: <20080912082301.GA28385@infradead.org>
References: <20080912025733.E55F415420D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912025733.E55F415420D@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 07:57:33PM -0700, Roland McGrath wrote:
>     3. arch_ptrace()
> 
>           * You must define arch_ptrace() and not #define __ARCH_SYS_PTRACE.

__ARCH_SYS_PTRACE is already gone :)

> 
>     4. compat_arch_ptrace()
> 
>           * If your arch uses CONFIG_COMPAT, you must define
>             compat_arch_ptrace() and #define __ARCH_WANT_COMPAT_SYS_PTRACE.

This should be gone for 2.6.28, too.  (no ACK from the ia64 people yet,
but mips and parisc are doen for sure)

