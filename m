Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXL2QJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXL2QJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 11:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXL2QJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 11:09:51 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:16278 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbXL2QJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 11:09:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TqNJiw3g0blBIiRb8GMawIGTDu26R1eM3JIbGLj72Z3z8b/egY3VUqPjef7vEn3g0U3r3O0T2bd7OdLE3vYvujkFrhu8MiU0wNlLW8b/hZEW5XxYsmNNDSUIslLTa/KF99Ffxzh4w+gKO9v0sy5DnEb73E9UvxqbjqdxRqF/wFM=
Message-ID: <47767148.2010209@gmail.com>
Date: Sat, 29 Dec 2007 17:09:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 1/1] mxser, remove it
References: <1198836540-8042-1-git-send-email-jirislaby@gmail.com>	<Pine.LNX.4.64.0712290211240.29013@fbirervta.pbzchgretzou.qr> <20071229022329.39f6162a@the-village.bc.nu>
In-Reply-To: <20071229022329.39f6162a@the-village.bc.nu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2007 03:23 AM, Alan Cox wrote:
>>> +static int mxvar_baud_table[] = {
>>> +	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400,
>>> +	4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
>>> +};
>>> +static unsigned int mxvar_baud_table1[] = {
>>> +	0, B50, B75, B110, B134, B150, B200, B300, B600, B1200, B1800, B2400,
>>> +	B4800, B9600, B19200, B38400, B57600, B115200, B230400, B460800, B921600
>>> +};
>> Constify both, if possible?
> 
> These are not portable - baud rate tables vary for some platforms. No
> driver should be touching Bxxx coding itself any more. Use the tty_
> functions to decode and encode baud rates.

Thanks for reviews, I'll post fixes for all the issues as separate patches.
