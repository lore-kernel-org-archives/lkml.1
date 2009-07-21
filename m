Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZGUAMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZGUAMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZGUAMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:12:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:59320 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbZGUAME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:12:04 -0400
Message-ID: <4A650786.1030501@kernel.org>
Date: Mon, 20 Jul 2009 17:10:46 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 01/10] ehci early_printk: split ehci debug driver from
 early_printk.c
References: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com> <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Move the dbgp early printk driver in advance of refactoring and adding
> new code, so the changes to this code are tracked separately from the
> move of the code.
> 
> The drivers/usb/early directory will be the location of the current
> and future early usb code for driving usb devices prior initializing
> the standard interrupt driven USB drivers.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  arch/x86/kernel/early_printk.c |  715 ---------------------------------------
>  drivers/usb/Makefile           |    1 +
>  drivers/usb/early/Makefile     |    5 +
>  drivers/usb/early/ehci-dbgp.c  |  723 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/usb/ehci_def.h   |    6 +
>  5 files changed, 735 insertions(+), 715 deletions(-)
>  create mode 100644 drivers/usb/early/Makefile
>  create mode 100644 drivers/usb/early/ehci-dbgp.c

before this patch, we could use dbgp without compiling USB susbsystem in...

YH
