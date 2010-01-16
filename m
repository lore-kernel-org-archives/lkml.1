Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0APIDQ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 03:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210Ab0APIDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 03:03:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0APIDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 03:03:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] compat_ioctl: Supress "unknown cmd" message on serial /dev/console
Date: Sat, 16 Jan 2010 09:02:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <1263133756-27804-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1263133756-27804-1-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001160902.40931.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/PO9emaBZCW2dUYA5LUQLzcwiKitN+bZQ2aMn
 gs7CULRQqAFKNagf3XDo7QV1D3s8meAf1IZRr11cx/X8sA5nyE
 eZTYqW92IjeUwE8TFUaUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 January 2010, Atsushi Nemoto wrote:
> After the commit fb07a5f8 ("compat_ioctl: remove all VT ioctl
> handling"), I got this error message on 64-bit mips kernel with 32-bit
> busybox userland:
> 
> ioctl32(init:1): Unknown cmd fd(0) cmd(00005600){t:'V';sz:0} arg(7fd76480) on /dev/console
> 
> The cmd 5600 is VT_OPENQRY.  The busybox's init issues this ioctl to
> know vt-console or serial-console.  If the console was serial console,
> VT ioctls are not handled by the serial driver.
> 
> And by quick search, I found some programs using VT_GETMODE to check
> vt-console is available or not.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks for adding it to your tree, Greg. I'm a bit slow on
email currently, as I'm travelling.

	Arnd
