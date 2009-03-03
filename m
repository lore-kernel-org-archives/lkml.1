Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZCCCst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZCCCst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZCCCsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:48:41 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:55226 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbZCCCsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:48:40 -0500
Date: Tue, 3 Mar 2009 13:48:37 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29-rc6 bombs while compiling a kernel for a
	linkstation/kurobox
Message-ID: <20090303024837.GC24834@bilbo.ozlabs.org>
Mail-Followup-To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>,
	linux-kernel@vger.kernel.org
References: <20090302094303.GA29819@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090302094303.GA29819@ime.usp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:43:03AM -0300, Rogério Brito wrote:

<snip>

> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> arch/powerpc/platforms/built-in.o: In function `linkstation_setup_arch':
> linkstation.c:(.init.text+0x218): undefined reference to `physmap_set_partitions'
> drivers/built-in.o:(__ksymtab+0x9f8): undefined reference to `physmap_set_partitions'
> make: *** [.tmp_vmlinux1] Error 1
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> I didn't have such problems with, say, kernel 2.6.28. If anybody could
> help, I would be glad to test any patches.
> 
> (Well, I already tried "blindly" adding an EXPORT_SYMBOL to
> physmap_set_partitions under the mtd subtree, but it wasn't enough to
> fix this issue).

Looks to me like you need to define CONFIG_MTD_PHYSMAP_COMPAT in your .config.


Yours Tony
