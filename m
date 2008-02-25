Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYBYCOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYBYCOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYBYCOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:14:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:21486 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYBYCOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:14:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O5fyZ77RLwv4nPr/diFEBZmHV5M9STzchjpoKT4pFkL0BhjwQQU2hKMf9VDzh3BtV1ZPD/ezZUYkJ6hBj7+LSAdq/eXCse1Vwf1sRsuKWf82zZ451GqLSXfE2WMeiBDrBmhWTVHfpc9yF+6KWKW8QDY8Vnz3kKkAplDZXGNZpaA=
Message-ID: <a8e1da0802241814x48e169f2v82823c55412fc534@mail.gmail.com>
Date: Mon, 25 Feb 2008 10:14:36 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Dave Jones" <davej@codemonkey.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: boot_delay broken ?
In-Reply-To: <20080224004615.GA31012@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080224004615.GA31012@codemonkey.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 8:46 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
> The boot_delay switch seems to be behaving strangely in the
>  current -git.  Setting it to =10 makes the output 'bursty'
>  it becomes slow for some printk's whilst others scroll by
>  at regular speed.
>  Setting it any higher than that seems to make it pause for
>  a really long time before it outputs any text at all.

On my side there's this issue for a long time
http://lkml.org/lkml/2007/8/8/79

>
>  x86 timer changes perhaps ?
>
>         Dave
>
>  --
>  http://www.codemonkey.org.uk
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
