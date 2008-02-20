Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbYBTXT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbYBTXT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbYBTXSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:18:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:7090 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbYBTXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=p7YvSqIn91eVCmViyws2IWe8jPPpB5YU/t4xIhT2Xa6tvyza34GCIFuEIIJwiVSd28qm1frars4J6T+3CSnNYgznRdMN5DjKRsXDxYxzLBx1b6R/YIzqjgX2ZyM4u0Gay1nYexqQlLmkLjb+Py7bf2l9mze7orw0DjT2YeidZJk=
Message-ID: <47BCB54E.5090203@gmail.com>
Date: Thu, 21 Feb 2008 00:18:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] moxa: prepare for BKL pushdown
References: <20080220201857.04626cac@core>
In-Reply-To: <20080220201857.04626cac@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2008 09:18 PM, Alan Cox wrote:
> Moxa needs a few routines wrapping with the BKL for now. It also snoops
> the TIOCG/SSOFTCAR function so needs its own implementation for now. That
> wants fixing by turning it into a termios set downcall into the drivers
> later.

I'm taking care of this one. I'll apply it on the top of my changes, if it will 
be still needed (open/close/hangup/ioctl seems not).

> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/moxa.c linux-2.6.25-rc2-mm1/drivers/char/moxa.c
> --- linux.vanilla-2.6.25-rc2-mm1/drivers/char/moxa.c	2008-02-19 11:03:00.000000000 +0000
> +++ linux-2.6.25-rc2-mm1/drivers/char/moxa.c	2008-02-20 11:45:50.000000000 +0000
