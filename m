Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZKQRKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZKQRKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZKQRKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:10:17 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50536 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZKQRKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:10:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kE6UNFHYtZv11sPc0zePi6ZtlqHm4YHgFFud7Zw1VcjpYv1/t3iayGGT3sTgfR+0Ww
         9ogIPE4cQ3L9ajWA1b/3IFQ/W/dOTCF9BbUW5WyJgErNLbA2gPMAl4E7tu7/0zQT+2pT
         6+vNblefk+bCvsDV1DzwsFlTZgoqCXRFxtr6Y=
Message-ID: <4B02D8F9.2090208@panasas.com>
Date: Tue, 17 Nov 2009 19:10:17 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 17 (exofs)
References: <20091117195309.6cc3ead0.sfr@canb.auug.org.au> <20091117090248.bb66c230.rdunlap@xenotime.net> <4B02D879.4010403@panasas.com>
In-Reply-To: <4B02D879.4010403@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 07:08 PM, Boaz Harrosh wrote:
> On 11/17/2009 07:02 PM, Randy Dunlap wrote:
>> On Tue, 17 Nov 2009 19:53:09 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20091116:
>>
>>
>> on i386 (X86_32):
>>
>> fs/built-in.o: In function `exofs_sbi_read':
>> (.text+0x592964): undefined reference to `__umoddi3'
>>
>> ---
>> ~Randy
> 
> exofs_sbi_read is a totally simple loop thing. What does the
> __umoddi3 means? Please help?
> 
> Boaz

OK I think I get it. It's that u64 mod (%) operation. I'll try to
find a ready made macro for that. Sorry

Boaz

