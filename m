Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYGUATf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYGUATf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYGUAT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:19:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36996 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbYGUATZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:19:25 -0400
Date: Sun, 20 Jul 2008 18:19:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 9/22] ia64: Introducing asm/syscalls.h
Message-ID: <20080721001909.GA24246@parisc-linux.org>
References: <1216592500.3679.14.camel@jaswinder.satnam> <1216592798.3679.22.camel@jaswinder.satnam> <1216592879.3679.24.camel@jaswinder.satnam> <1216593035.3679.27.camel@jaswinder.satnam> <1216596035.3679.95.camel@jaswinder.satnam> <1216596106.3679.98.camel@jaswinder.satnam> <1216596325.3679.104.camel@jaswinder.satnam> <1216596669.3679.112.camel@jaswinder.satnam> <1216596749.3679.115.camel@jaswinder.satnam> <1216596835.3679.117.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216596835.3679.117.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 05:03:55AM +0530, Jaswinder Singh wrote:
> Declaring arch-dependent syscalls for ia64 architecture
> +#ifndef CONFIG_PCI
> +asmlinkage long sys_pciconfig_read(unsigned long, unsigned long,
> +				   unsigned long, unsigned long, void *);
> +asmlinkage long sys_pciconfig_write(unsigned long, unsigned long,
> +				    unsigned long, unsigned long, void *);
> +#endif /* CONFIG_PCI */

These are already declared in linux/syscalls.h

And frankly, we should just make these return -ENOSYS always.  Any
software that uses them is stuffed on machines with multiple domains.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
