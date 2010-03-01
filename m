Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0CAUAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:00:08 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:56177 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0CAUAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TyYhwH2fYqDgy6GM7UwbWG2qhJZagbGiDfD3Oxr0gbNAjQGlg5l6BxB3VsajG5jlMj
         Uvjj6NOFH4LeZ44yP56ceMGUk/WJNqS4hMhl97nBx91imYkWtITDHLfIECXRuRcbIevY
         Dke2S20B6LlWmb3/ceiOZ7VbI5vCLPmrP8pzY=
Message-ID: <4B8C1CBA.5050007@gmail.com>
Date: Tue, 02 Mar 2010 06:59:54 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel 
 before decompression'
References: <4B80946D.1030503@gmail.com> <4B80C892.9000303@zytor.com>	 <4B80CA55.3040402@zytor.com> <d66caabb1002211451s5a68565fue6096e17b99402f7@mail.gmail.com> <4B88A865.2080009@gmail.com> <4B8BAB5C.5030707@gmail.com> <4B8BEF71.5040105@zytor.com> <4B8C184E.2000400@gmail.com> <4B8C18D0.2050208@zytor.com>
In-Reply-To: <4B8C18D0.2050208@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 03/01/2010 11:41 AM, Graeme Russ wrote:
>> H. Peter Anvin wrote:
>>> On 03/01/2010 03:56 AM, Graeme Russ wrote:
>>>> I have done a little more digging. By adding an ascii string before
>>>> relocated: label, I am able to determine that the int3 after the relocated:
>>>> label exists in bzImage at offset 0x1C3FD7
>>>>
>>>> EAX holds (for the jump) 0x5379d0 (different bzImage of course). The
>>>> contents of memory at this address is in bzImage at offset 0x1C09D7 - A
>>>> difference of 0x3600 (seems too even to be random)
>>>>
>>>> I'm obviously doing something hideously wrong, but what?
>>>>
>>> 0x3600 sounds like the size of the real-mode code in bzImage.
>>>
>> But what could I be doing to cause the miscalculation? From what I
>> understand, everything looks to be calculated at build time
>>
> 
> If I were to guess, you loaded the entire bzImage into high memory,
> rather than just the PM portion thereof.
> 
I which case I would not think I would be jumping to 0x100000 as the
entry-point for the 32-bit protocol (at a guess I would be jumping to 0x103600)

Graeme
