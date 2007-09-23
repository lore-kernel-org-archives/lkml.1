Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbXIWU7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbXIWU7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXIWU7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:59:39 -0400
Received: from barikada.upol.cz ([158.194.242.200]:50138 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXIWU7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:59:38 -0400
Date: Sun, 23 Sep 2007 23:15:17 +0200
To: Bernhard Walle <bwalle@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/7] Extended crashkernel command line
Message-ID: <20070923211517.GU24301@flower.upol.cz>
References: <20070920171845.774383000@stravinsky.suse.de> <20070920171846.062209000@stravinsky.suse.de> <E1IZEAi-00051i-23@flower> <20070923201943.GA5272@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070923201943.GA5272@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 10:19:43PM +0200, Bernhard Walle wrote:
[]
> >  +int __init get_crashkernel_params(u64 *memsize, u64 *addrbase, char *cmdline, u64 ram);
> 
> Andrew, what's your opinion on this? Whould I resend the patch with
> shorter type names?

Also, maybe it will be better to extend linux/lib/cmdline.c->{get_range(), get_range()}
to handle that stuff? And maybe new functionality can be built up-on the current one: 

- crashkernel=512M-2G:64M,2G-:128M@offset
+ crashkernel=512M-2G,64M,2G-,128M,,offset
?

OK, OK, you are already using and maintaining new syntax, but still.
_____
(`Mail-Followup-To' ignored)
