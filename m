Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbXEXE5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbXEXE5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbXEXE5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:57:33 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:53669 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbXEXE5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:57:32 -0400
Message-ID: <46551A93.6050801@gmail.com>
Date: Thu, 24 May 2007 06:54:43 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>	<46541F65.9060507@msgid.tls.msk.ru>	<20070523100416.93835196.randy.dunlap@oracle.com>	<465492C8.9060003@gmail.com> <20070523135513.b3573f52.randy.dunlap@oracle.com>
In-Reply-To: <20070523135513.b3573f52.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2007 10:55 PM, Randy Dunlap wrote:

>>>> That's a good source of confusion.  To me, "notime" means something
>>>>  like "don't bother calculating time", instead of the proposed 
>>>> behavior.  Can't it be something like 'nologts' (no log timestamps)
>>>>  or nots or notimestamps or nologtime instead
>>> 
>>> "nologtime" is OK with me.  or does it confuse people in a different
>>> way?  Anyone else?
>> 
>> The CONFIG option is called CONFIG_PRINTK_TIME. How about "noprintktime"? At 
>> least nicely to the point...
> 
> Actually I'm concerned about total kernel command line length,
> so using option names that are "long" when short will do is not good IMO.
> 
> I.e., I can easily overflow a 255-byte command line length buffer,
> so Shorter is Better.

Okay. I would by the way not be against turning the timestamping off by 
default and turning it _on_ with a "timestamps" or "logtime" or whatever 
option. The information is sometimes handy for seeing the (clustering of) 
event times so I've been compiling it in for a while on some boxes but in 
the majority case for me it's noise taking up printk real estate...

Rene.

