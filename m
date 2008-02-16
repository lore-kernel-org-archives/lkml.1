Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYBPLiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYBPLiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYBPLiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:38:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:28401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYBPLiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:38:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hKoWTdt3XTQzZ00j4wzRw9l6Z3kc9qZcZWL7yRTU3Hpbhj9p5CoQxghK1sG0tHozRUKOkIOd3YV27GZLSiGyrRCEhQi9g0Ff9/WZotvPBlVd97w4UPmuCIVLXqiv9nDjCiQ71bBZNeWfntah/ZaKapEcuualU19lU9WwD0B2oPw=
Date: Sat, 16 Feb 2008 12:37:26 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Russell Leidich <rml@google.com>, Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.25-rc2-mm1: build failure (x86)
Message-ID: <20080216113722.GA9041@joi>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216105737.GA6561@joi> <20080216030949.5b11ba4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216030949.5b11ba4c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 03:09:49AM -0800, Andrew Morton wrote:
> On Sat, 16 Feb 2008 11:59:07 +0100 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > arch/x86/kernel/built-in.o: In function `amd_smp_thermal_interrupt':
> > (.text+0xe03b): undefined reference to `mce_log_therm_throt_event'
> > arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> > (.text+0x12239): undefined reference to `setup_trampoline'
> > 
> > #
> > # Automatically generated make config: don't edit
> > # Linux kernel version: 2.6.25-rc2-mm1
> > # Sat Feb 16 11:32:49 2008
> 
> ho hum, thanks.  I think I'll drop x86-amd-thermal-interrupt-support.patch.
>  I don't think it's the final version anwyay.
> 
Ok, I had to revert x86-remove-pt_regs-arg-from-smp_thermal_interrupt before x86-amd-thermal-interrupt-support.

Second error vanished when I reverted "suspend: wakeup code in C".
