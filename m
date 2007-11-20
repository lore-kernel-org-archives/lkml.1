Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbXKTTEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbXKTTEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbXKTTDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:03:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903AbXKTTDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:03:53 -0500
Date: Tue, 20 Nov 2007 11:04:13 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: [PATCH] mct232: speed, new termios and compliance cleanups
Message-Id: <20071120110413.5f84e092.zaitcev@redhat.com>
In-Reply-To: <20071119152211.4be48986@the-village.bc.nu>
References: <20071119152211.4be48986@the-village.bc.nu>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 15:22:11 +0000, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Signed-off-by: Alan Cox <alan@redhat.com>

This looks good, but have a couple of comments. Maybe I can fix it up.

>   * we do not know how to support. We ignore them for the moment.
>   * XXX Rate-limit the error message, it's user triggerable.

This XXX item is fixed by this patch, so should be removed.

> +		/* FIXME: Can we use any divider - should we do
> +		   divider = 115200/value;
> +		   real baud = 115200/divider */
>  		switch (value) {
>  		case 300: break;

I do not understand this FIXME comment. What is wrong with current
code? The result of the function is given to the device's sequencer.
Do you want to get rid of the switch? Please unconfuse me.

-- Pete
