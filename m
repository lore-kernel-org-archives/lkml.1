Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0CACbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 21:31:16 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37206 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0CACbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 21:31:14 -0500
Date: Sun, 28 Feb 2010 21:31:10 -0500 (EST)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
cc: Denys Vlasenko <vda.linux@googlemail.com>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Anders Kaseorg <andersk@ksplice.com>,
       Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 17/24] Rename .text.reset to .text..reset.
In-Reply-To: <1266624237-22372-18-git-send-email-vda.linux@googlemail.com>
Message-ID: <alpine.DEB.1.10.1002282126420.6474@dr-wily.mit.edu>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com> <1266624237-22372-18-git-send-email-vda.linux@googlemail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard,

How does the .text.reset section get populated on the avr32 architecture?

As far as I can tell, there's no code in the kernel to put anything in the 
.text.reset section, yet the linker script places that section at the 
start of the text section.

	-Tim Abbott

On Sat, 20 Feb 2010, Denys Vlasenko wrote:

> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> ---
>  arch/avr32/kernel/vmlinux.lds.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
> index 9cd2bd9..5d7fe57 100644
> --- a/arch/avr32/kernel/vmlinux.lds.S
> +++ b/arch/avr32/kernel/vmlinux.lds.S
> @@ -26,7 +26,7 @@ SECTIONS
>  		_stext = .;
>  		__init_begin = .;
>  			_sinittext = .;
> -			*(.text.reset)
> +			*(.text..reset)
>  			INIT_TEXT
>  			/*
>  			 * .exit.text is discarded at runtime, not
> -- 
> 1.6.2.4
> 
> 
