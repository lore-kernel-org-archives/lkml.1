Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYBJSA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYBJSA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYBJSAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:00:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:47152 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYBJSAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=jGPFMsqHwr5F0zag2fTMmnz7OPcuV6/rwCDKIJlG3/f+lWwCG8n9TJ/c+RKQe9U9KpLn4o9MALaKDnwPFNOo7230PgsuyVY61IhX0ETCEkJx1BV8RYbfKjOr7/+Kxi0rHJPhfs4cGAQUdhk8HzhPc1uVzZCwsRTUEb+GaR1WSaw=
Date: Sun, 10 Feb 2008 21:00:03 +0300
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: pci_proc_init: proc_dir_entry '00' already registered
Message-ID: <20080210180003.GC1754@martell.zuzino.mipt.ru>
References: <20080210100757.GA28322@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210100757.GA28322@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 11:07:57AM +0100, Olaf Hering wrote:
> Current Linus tree gives this new warning during bootup:
> 
> +proc_dir_entry '00' already registered
> +Call Trace:
> +[c00000007b0dfba0] [c00000000000e4b0] .show_stack+0x70/0x1bc (unreliable)
> +[c00000007b0dfc50] [c0000000000f2714] .proc_register+0x130/0x210
> +[c00000007b0dfd00] [c0000000000f299c] .proc_mkdir_mode+0x40/0x70
> +[c00000007b0dfd80] [c000000000276ed8] .pci_proc_attach_device+0xac/0x144
> +[c00000007b0dfe20] [c0000000005bdb3c] .pci_proc_init+0x74/0xac
> +[c00000007b0dfea0] [c0000000005a27ac] .kernel_init+0x1d0/0x394
> +[c00000007b0dff90] [c00000000001e258] .kernel_thread+0x4c/0x68

Can you insert dump_stack() when '00' is registered, not just second
time?
