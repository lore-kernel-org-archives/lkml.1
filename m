Return-Path: <linux-kernel-owner+w=401wt.eu-S1762364AbYBNVv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762364AbYBNVv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYBNVvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:51:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbYBNVvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:51:47 -0500
Date: Thu, 14 Feb 2008 13:50:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH] [WATCHDOG] it8712f_wdt support for 16-bit timeout
 values, WDIOC_GETSTATUS
Message-Id: <20080214135059.b72570f0.akpm@linux-foundation.org>
In-Reply-To: <76366b180802101911q2df5dc7i5d77840815252c88@mail.gmail.com>
References: <76366b180802101911q2df5dc7i5d77840815252c88@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 22:11:15 -0500
"Andrew Paprocki" <andrew@ishiboo.com> wrote:

> This patch adds support for 16-bit watchdog timeout values which are
> available in chip revisions >= 0x08. Values <= 65535 are seconds precision,
> otherwise minutes precision is used up to a maximum value of 3932100. Added
> implementation for WDIOC_GETSTATUS which checks the WDT status bit in the
> WDT control register.
> 
> Signed-off-by: Andrew Paprocki <andrew@ishiboo.com>
> ---
>   drivers/watchdog/it8712f_wdt.c |   82
> ++++++++++++++++++++++++++++++++--------
>   1 files changed, 66 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
> index 1b6d7d1..803c699 100644
> --- a/drivers/watchdog/it8712f_wdt.c
> +++ b/drivers/watchdog/it8712f_wdt.c

The patch is wordwrapped, space-stuffed and has tabs replaced with spaces. 
You hit the trifecta!

Please resend.  If you'd prefer to use an attachment rather than spending
half an hour wrestling your email client, feel free to do so ;)

