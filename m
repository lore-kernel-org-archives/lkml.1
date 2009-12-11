Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbZLKIi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbZLKIi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933386AbZLKIiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:38:21 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:43832 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761457AbZLKIiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:38:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jpAMUFnmM36jNjPwVWMhSKgh/psirk+rmik6cuAIfCXc0+Bktw+vgwh5WPkcsSAJYN
         TZuwCkZOyzK7+ZED9ACfs1vODoc8YRUzgZsVGxsnmMhegwqBH7lBGYj840+1JgI62NRB
         7cccAJ4vHksS8O2qa/s47UohAvY76NbQ55bXY=
MIME-Version: 1.0
In-Reply-To: <4B1FDDE2.1090507@draigBrady.com>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
	 <4B1FDDE2.1090507@draigBrady.com>
Date: Fri, 11 Dec 2009 16:38:27 +0800
Message-ID: <f9f38a550912110038y51c4d4c4g35b6267efca69d71@mail.gmail.com>
Subject: Re: Questions about Watch Dog Timer under Linux.
From: Cypher Wu <cypher.w@gmail.com>
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Less than 2 seconds is not a thing in our embedded system, the WDT
we've already used will time out every 1.6s, and only a WDI connection
to support timer clearing. I'm not sure if we depend on a user
application to clearing the dog directly, is this too short for Linux
since it's not a RTOS.


2009/12/10 Pádraig Brady <P@draigbrady.com>:
> On 09/12/09 14:47, Cypher Wu wrote:
>>
>> I'm used to work on embedded systems, the Watch Dog Timer in our
>> products is usually a seperate chip on the board wich will start to
>> work after power reset and will time out in 2 seconds. The system has
>> to start dog clearing from the very beginning and there have no way to
>> disable WDT.
>
> wow 2 seconds :(
>
> It's easy to patch grub stage 1 to pat the watchdog.
> I was even able to get support for the complicated iTCO intel
> watchdogs in there, though your watchdog may be much simpler.
>
> Then when the kernel started it patted the watchdog as normal.
>
> Note I did this to support robust remote upgrade (as the boot
> loader wasn't touched on upgrade), rather than to support a
> very short timeout.
>
> cheers,
> Pádraig.
>
