Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZCYBCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZCYBCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZCYBCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:02:21 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:45808 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZCYBCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:02:21 -0400
Message-ID: <49C98280.4020402@diamondcut.com.br>
Date: Tue, 24 Mar 2009 22:01:52 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; pt-BR; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, jnelson@jamponi.net
Subject: Re: Thinkpad T61 - Fan running a lot of time
References: <49C94620.8040309@diamondcut.com.br> <20090324232328.GA23356@khazad-dum.debian.net>
In-Reply-To: <20090324232328.GA23356@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> Renato S. Yamane wrote:
>> The fan speed is ~2600RPM (always under 3000RPM), and I think that is
>> not enough to cooling the processor, because is necessary 3min to
>> decrease 1°C in Core1 and only 40sec to increase 1°C.
>>
>> I think that is necessary a higher fan speed.
>
> Or a better thermal coupling between the fan assembly and the
> processor...  this is a weak area on thinkpads.
>
> If your box is still under warranty, I suggest you to use
> thinkpad-acpi fan control to keep your fan at level 7 (fastest normal
> fan level).  If that's not enough, call in for a motherboard
> replacement.

Updated BIOS to 7LETC5WW (2.25) and...

Fan speed is stabilished in ~3000RPM, temperature go to 42°C and fan 
speed still power-on.

# cat /proc/acpi/ibm/fan
status:         enabled
speed:          3028
level:          auto

# echo level 7 > /proc/acpi/ibm/fan
bash: echo: write error: Invalid argument

How can I change fan level?

Regards,
Renato
