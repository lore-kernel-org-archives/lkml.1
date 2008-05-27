Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYE0NaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYE0NaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYE0NaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:30:08 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:59473 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYE0NaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hrRdUNd43Xdf5lhTsqPxpxFLec+KK6TU9lzsQKTAh0USQ+3dTJHfP13lseQSiSXlHDhTeboXGh6mYstMPXuUlAeCO4bcnZDfic/FEnj3Czl3YY1UMXgo0GQpMCaUUvyw9uMlbX76KjhSBMBz9fcy/bTqCb6U/0tW5uPTnBh++iM=
Message-ID: <483C0CDD.2000409@gmail.com>
Date: Tue, 27 May 2008 15:30:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Noel (Sourceforge)" <noelb@users.sourceforge.net>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PROBLEM: Serial error
References: <1211836442.5745.1.camel@roswell.ausics.net> <483B3B7C.1000306@gmail.com>
In-Reply-To: <483B3B7C.1000306@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> On 05/26/2008 11:14 PM, Noel (Sourceforge) wrote:
>> serial comms error with smsclient  >2.6.25 , worked fine up until and
>> including 2.6.24.7

There is >2.6.25. It means post 2.6.26-rc1 inclusively?

> [...]
>> 01:0c.0 Serial controller: PLX Technology, Inc. PCI <-> IOBus Bridge
>> (rev 01) (prog-if 00 [8250])
>>         Subsystem: Stallion Technologies, Inc. Unknown device f010
> 
> Do you have some patched driver or whatever, that this binds?
> 
> [...]
>> Stallion Multiport Serial Driver: version 5.6.0
>> Stallion Intelligent Multiport Serial Driver: version 5.6.0
>> 0000:01:0c.0: ttyS4 at I/O 0xd880 (irq = 6) is a ST16654
>> 0000:01:0c.0: ttyS5 at I/O 0xd888 (irq = 6) is a ST16654
>> 0000:01:0c.0: ttyS6 at I/O 0xd890 (irq = 6) is a ST16654
>> 0000:01:0c.0: ttyS7 at I/O 0xd898 (irq = 6) is a ST16654
>> 0000:01:0c.0: ttyS8 at I/O 0xd8a0 (irq = 6) is a ST16654
>> 0000:01:0c.0: ttyS9 at I/O 0xd8a8 (irq = 6) is a ST16654
>> 0000:01:0c.0: ttyS10 at I/O 0xd8b0 (irq = 6) is a ST16654
>> 0000:01:0c.0: ttyS11 at I/O 0xd8b8 (irq = 6) is a ST16654 <-- phone line
>> in this port
>>
>>
>> suggestions or assistance appreciated.
> 
> The only significant change is
> ccfea3c98a10b9d4d49b899616a06594ec976d7d
> could you try to revert it and re-test?


 > Thanks
 > Reverted, but problem remains.


If you double checked this, trying to CC Alan if he doesn't have a clue.
For reference:
http://lkml.org/lkml/2008/5/26/260
