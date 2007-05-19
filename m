Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbXESSL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbXESSL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764129AbXESSLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:11:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764120AbXESSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:11:46 -0400
Date: Sat, 19 May 2007 11:09:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: kconfig select warnings bogus?
Message-Id: <20070519110944.2a52061e.akpm@linux-foundation.org>
In-Reply-To: <20070519151523.GA26724@uranus.ravnborg.org>
References: <20070519151523.GA26724@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 17:15:23 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> We see a lot of these lately:
>   GEN     /home/bor/build/linux-2.6.22/Makefile
> scripts/kconfig/conf -s arch/i386/Kconfig
> drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
> drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
> drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> 
> 
> Do this warning really add any value or should we just ignore them like this?
> 

They always indicate Kconfig bugs, don't they?  If so, we should keep the
warning.

We should also fix the Kconfig bugs but for some reason they tend to hang
around for ages and ages.

