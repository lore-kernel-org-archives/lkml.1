Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0CAEmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 23:42:24 -0500
Received: from relay.atmel.no ([80.232.32.139]:52666 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0CAEmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 23:42:23 -0500
Date: Mon, 1 Mar 2010 11:41:11 +0700
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Bjorn Wesen <bjornw@axis.com>, Tim Bird <tim.bird@am.sony.com>,
       Tim Abbott <tabbott@ksplice.com>, Anders Kaseorg <andersk@ksplice.com>,
       Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 17/24] Rename .text.reset to .text..reset.
Message-ID: <20100301114111.06234d49@hskinnemoen-d830>
In-Reply-To: <1266624237-22372-18-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
	<1266624237-22372-18-git-send-email-vda.linux@googlemail.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> wrote:
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

Please remove it instead. I'm sure there's no code which actually
places something in .text.reset, but if there is, this patch would
break it in exactly the same way as removing it altogether would do.

Haavard
