Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZFONb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZFONb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZFONbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:31:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34930 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZFONbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:31:49 -0400
Date: Mon, 15 Jun 2009 07:31:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arnd Bergmann <arnd@arndb.de>
Cc: liqin.chen@sunplusct.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] asm-generic: add EMAXERRNO
Message-ID: <20090615133151.GI19977@parisc-linux.org>
References: <OF48364F7F.ED6F93C7-ON482575D6.0042A7E0-482575D6.0043654D@sunplusct.com> <200906151530.10299.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906151530.10299.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:30:09PM +0200, Arnd Bergmann wrote:
> Some architectures want to flag error returns from a syscall based on
> the return value. The range from zero to -511 is for errors that
> we can return to user space, so add a #define for this to
> include/asm-generic/errno.h.

I thought we could return anything up to -4095.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
