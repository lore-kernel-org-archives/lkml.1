Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbYA1XYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbYA1XYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764800AbYA1XSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:18:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:5423 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbYA1XSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Hp08vdUBgVTPJ9lk+nyKrOhc2V8WdIFLnxHiO2HUQFkdZu/Hr64+K/3+77ZTMnAcEPkdGkikxFkwOwXqfQhggrHRWx5O5tTxRGpAY1m6jqQwxE0X/dWUsN4T6WEGzlzY5arrlU67WVBMGF7J2sqN1Zg7wukaD+Td7Rs/tqFYlVg=
Message-ID: <479E62AB.3010603@gmail.com>
Date: Tue, 29 Jan 2008 00:18:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: dsterba@suse.cz, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz,
       stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
References: <20080128171929.GA3906@ds.suse.cz> <20080128100854.fe7acad8.rdunlap@xenotime.net>
In-Reply-To: <20080128100854.fe7acad8.rdunlap@xenotime.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2008 07:08 PM, Randy Dunlap wrote:
>> +/*
>> + * @return 1 if something has been received from hw
> 
> What's with the '@'?
...
>> +
>> +/*!
> 
> and the '!' ?
> 
>> + * @return true if the card is physically present.
>> + */

What exactly is wrong with @ and !? It's perfectly doxygen-styled.

>> diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
>> new file mode 100644
>> index 0000000..cab5722
>> --- /dev/null
>> +++ b/drivers/char/pcmcia/ipwireless/main.c
>> @@ -0,0 +1,496 @@
[...]
>> +module_param(major, int, 0);
>> +module_param(ipwireless_debug, int, 0);
>> +module_param(ipwireless_loopback, int, 0);
>> +module_param(ipwireless_out_queue, int, 0);
>> +MODULE_PARM_DESC(major, "ttyIPWp major number [0]");
>> +MODULE_PARM_DESC(ipwireless_debug, "switch on debug messages [0]");
>> +MODULE_PARM_DESC(ipwireless_debug, "switch on loopback mode [0]");
>> +MODULE_PARM_DESC(ipwireless_debug, "set size of outgoing queue [1]");
> 
> Will these parameters be documented anywhere?

Anyway the descs are wrong. Those 3 are for the only one variable.

