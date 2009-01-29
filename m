Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZA2PEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZA2PEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZA2PEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:04:06 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:8144 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZA2PED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:04:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vVXfF+Izy4YLGgdF4TBtQey7aMZFkVUq1FzVOhNWHWk2zMwWRk6fHzKmBU9Qbrpku3
         ZYu9EKKvzTp4WHLhAIZanCCPOTL/BfHKJCYO7BKduHtNVXnUDjUuxLVnw+pJGcQpp01S
         mw5znzRDQpXEUYoYySj8wxiQEdTSxPTGZ22ls=
MIME-Version: 1.0
In-Reply-To: <200901291354.04005.oliver@neukum.org>
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
	 <alpine.LSU.2.00.0901291342050.15159@fbirervta.pbzchgretzou.qr>
	 <200901291354.04005.oliver@neukum.org>
Date: Thu, 29 Jan 2009 16:04:02 +0100
Message-ID: <1a26b4920901290704v35666410u437d92810c1254c1@mail.gmail.com>
Subject: Re: how to change serial device<->port association
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Oliver,

Thank you very much for your help. I'm going to try your suggestion.

p

2009/1/29 Oliver Neukum <oliver@neukum.org>:
> Am Thursday 29 January 2009 13:43:02 schrieb Jan Engelhardt:
>> >Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ sharing disabled
>> >serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> >serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>> >serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a NS16550A
>> >serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a NS16550A
>> >00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> >00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>> >00:0b: ttyS2 at I/O 0x3e8 (irq = 10) is a NS16550A
>> >00:0c: ttyS3 at I/O 0x2e8 (irq = 11) is a NS16550A
>> >
>> >I would like to change the map ttySx -> I/O port. I try with setserial
>> >but it doesn't work....Any clue?
>
> They are just names. Create device nodes with the name you like and
> the correct major:minor combination. Udev can do this for you.
>
>        Regards
>                Oliver
>
>
