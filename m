Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYDIG6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYDIG6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYDIG5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:57:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31769 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYDIG5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bekaRPDq76HCJNbLIzomabPn5ApZldUZEiys0lV80mhoUEE4Pk2UTc9iJzWWN+Du044cjWVcV/oqtgte6bbGh025/QpDWLh3XlGXggQrNhucWYsA54B9g/IXdvNsMk+ER5t0DNXA68i7hKtmGUiqL26ICihmVvU4jFtHbHmfkHg=
Message-ID: <47FC68EC.40602@gmail.com>
Date: Wed, 09 Apr 2008 08:57:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org,
       Paul Hardwick <p.hardwick@option.com>
Subject: Re: [PATCH] tty/serial: Lay the foundations for the next set of reworks
References: <20080408165839.47df4517@core>	<47FBEA09.6090507@gmail.com> <20080408231348.190abf20@core>
In-Reply-To: <20080408231348.190abf20@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2008 12:13 AM, Alan Cox wrote:
>> Well, how exactly the card behaves on 1 byte write? And how did the .write 
>> protect against it?
> 
> One byte writes work fine via the write path and already occur. 

I guessed so, because there is no protection against one byte writes in .write.

> I suspect
> the original author forgot to turn echo off and saw fun things happening
> between the inbuilt modem emulation and the Linux side.

He was Cced, I hope he'll make things clear :).
