Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbXDBExw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbXDBExw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 00:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXDBExw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 00:53:52 -0400
Received: from gw.goop.org ([64.81.55.164]:43379 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbXDBExv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 00:53:51 -0400
Message-ID: <46108C52.7030301@goop.org>
Date: Sun, 01 Apr 2007 21:53:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com> <460F511E.2090102@goop.org> <46103DF2.30001@goop.org> <20070402023846.GC28561@khazad-dum.debian.net>
In-Reply-To: <20070402023846.GC28561@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Sun, 01 Apr 2007, Jeremy Fitzhardinge wrote:
>   
>> control problems.  Perhaps the ambient temperature was lower when I
>> reported success.
>>     
>
> You can use ibm-acpi to properly track your thinkpad thermal sensors, load
> it with the "experimental=1" parameter, and look at what gets exported at
> /proc/acpi/ibm/thermal.
>   

Interesting.  The first number corresponds with the ACPI THM0
temperature, but I can't see anything corresponding to THM1.  Is there
something that documents what all the temperatures are measuring in an
X60?  Thinkwiki doesn't seem to have any info.

ezr:pts/1; cat /proc/acpi/ibm/thermal
temperatures:   72 55 -128 65 40 -128 35 -128 51 53 -128 -128 -128 -128
-128 -128

> You can also use /proc/acpi/ibm/fan to check the fan's state.  And use the
> "level 7" /proc/acpi/ibm/fan command to set the emergency cooling level, and
> "level disengaged" command to set the really badass fan cooling level (might
> damage your hardware, we don't know if it is safe and IBM/Lenovo isn't
> talking).
>   

It's set to auto.  Presumably that means its tied into the temperature
sensors and will be able to keep the temp under control...

    J

