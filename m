Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYLXC2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYLXC2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 21:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYLXC2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 21:28:31 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:54365 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYLXC2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 21:28:30 -0500
Date: Wed, 24 Dec 2008 04:27:59 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: David Brownell <david-b@pacbell.net>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, gregkh@suse.de,
       felipe.balbi@nokia.com, davinci-linux-open-source@linux.davincidsp.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] musb: fix DaVinci build again
Message-ID: <20081224022757.GA10240@frodo>
Reply-To: me@felipebalbi.com
References: <200812072341.50012.sshtylyov@ru.mvista.com> <200812230939.00508.david-b@pacbell.net> <49517305.4000100@ru.mvista.com> <200812231707.48195.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812231707.48195.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just a note before a comment. I'm gonna be on vacations during this and
next week. Trying to get better from a really terrible flu so I won't be
hacking too much during this time.

Anyways, once comment below.

On Tue, Dec 23, 2008 at 05:07:47PM -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Build fixes that somehow got stripped out of the earlier build
> fix patch ...
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/usb/musb/davinci.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- a/drivers/usb/musb/davinci.c
> +++ b/drivers/usb/musb/davinci.c
> @@ -31,10 +31,11 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/gpio.h>
> +#include <linux/gpio.h>

you're including <linux/gpio.h> twice.

-- 
balbi
