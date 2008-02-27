Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYB0RfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYB0RfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYB0RfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:35:10 -0500
Received: from hell.org.pl ([193.0.71.61]:1595 "EHLO hell.org.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbYB0RfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:35:09 -0500
X-Greylist: delayed 1908 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 12:35:09 EST
In-Reply-To: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk>
References: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl>
Cc: corentincj@iksaif.net, sziwan@users.sourceforge.net,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Karol Kozimor <sziwan@hell.org.pl>
Subject: Re: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
Date: Wed, 27 Feb 2008 18:03:16 +0100
To: Julia Lawall <julia@diku.dk>
X-Mailer: Apple Mail (2.753)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-02-2008, at 21:42, Julia Lawall wrote:
>  	if (invert)		/* invert target value */
> -		led_out = !led_out & 0x1;
> +		led_out = !(led_out & 0x1);
>
>  	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
>  		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",


IIRC we're just supposed to flip the last bit here, so the original  
code is correct.
Best regards,

-- 
Karol Kozimor
sziwan@hell.org.pl


