Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbXGCX1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbXGCX1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXGCX1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:27:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbXGCX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:27:44 -0400
Date: Tue, 3 Jul 2007 16:27:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [PATCH 2.6.21 2/3] x86_64 EFI64 support Try #2
Message-Id: <20070703162734.bee2da7c.akpm@linux-foundation.org>
In-Reply-To: <20070702170707.878565000@em64tdvp.jf.intel.com>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
	<20070702170707.878565000@em64tdvp.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jul 2007 10:06:16 -0700
Chandramouli Narayanan <mouli@linux.intel.com> wrote:

> EFI x86_64 support Patch 2 of 3 (try #2)
> ----------------------------------------
> - E820 conversion integration implemented
> - A way to override machine_emergency_restart is implemented so that
>   EFI support can provide its own implementation.
> - The variable efi_enabled is still retained as it is used across
>   archictures with CONFIG_EFI option. 
>   

Does the above text completely describe this patch?

> 
> diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/aperture.c linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/aperture.c
> --- linux-2.6.21-orig/arch/x86_64/kernel/aperture.c	2007-04-25 20:08:32.000000000 -0700
> +++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/aperture.c	2007-06-25 13:59:54.000000000 -0700

Lots of little glitches there which checkpatch.pl will point out.
