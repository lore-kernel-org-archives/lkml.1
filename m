Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZAaR1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZAaR1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZAaR0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:26:54 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:54339 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZAaR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:26:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=PTLVabbwrW9mfGde9/HAy20n3aAVd1dgwrz4dTxoL2i2c63OnnarKJjoyIu+4gtDXZ
         6isd0uhA3fHg3TgLWxqg4dU84p92z7gXZR/csI6Hm56G7tHzoNb1oC4fDkfVemr6LS/b
         xN5RObEqSzWSqppA5cpghgbnLNmIVwZ9w9y1k=
MIME-Version: 1.0
In-Reply-To: <1233415163.28790.1297773583@webmail.messagingengine.com>
References: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
	 <20090131134651.GC28763@khazad-dum.debian.net>
	 <6bd94bae0901310604u6ed876f1n77b7e2561f479ad1@mail.gmail.com>
	 <1233415163.28790.1297773583@webmail.messagingengine.com>
Date: Sat, 31 Jan 2009 18:26:51 +0100
Message-ID: <6bd94bae0901310926q53c0af6ftcded8b9846be521f@mail.gmail.com>
Subject: Re: Spurious Filesystem corruption with ext3 + large (<400GB) hw RAID 
	partition + SMP
From: Manfred Wassmann <tux.wassmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 4:19 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> Please reply to the list... and it is probably useful to add which kind of SATA chip the 3Ware card uses.
> I only asked for some information I knew would be required, but probably I won't be able to help much.

Thank you very much and sorry, my reply was intended to go to the list
but it's the first time I use google mail with a list and it is much
different.

Well I have neither hardware nor documents around here and the dmesg
output doesn't tell me anything more than I already stated :(

>> I didn't think it could be the memory because the problem occurs with
>> the 32bit kernel alone but what do you suggest? I only have remote
>> access to the system over the weekend.
>
> Try one of the memtest utils that don't need to run from the boot over the weekend. If nothing fails, run the real thing on Monday.

OK memtest is running but there is one other thing I forgot to
mention, we had the same problem on two different machines.

Furthermore it always affects the ext3 filesystem and not the ext2
partition which is much smaller with only 1GB and mounted r/o on the
final system, but that is where most of the software gets installed.
And the problem is triggered at installation time so don't you think
it should more likely hit the ext2 partition if it is not an ext3
problem?

regards Manfred Wassmann
-- 
Unix "Birthday" on 2009-02-13 23:31:30 UTC
...it's 1234567890 seconds since the epoch.
