Return-Path: <linux-kernel-owner+w=401wt.eu-S965967AbXFGTx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965967AbXFGTx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932802AbXFGTxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:53:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762225AbXFGTxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:53:46 -0400
From: Olaf Dietsche <olaf.dietsche@olafdietsche.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <200706012340.54394.rjw@sisk.pl>
	<87hcpr2ubl.fsf@goat.bogus.local> <200706020037.16615.rjw@sisk.pl>
	<87wsykpweu.fsf@goat.bogus.local> <20070607122303.GA8938@ucw.cz>
Date: Thu, 07 Jun 2007 21:54:51 +0200
In-Reply-To: <20070607122303.GA8938@ucw.cz> (Pavel Machek's message of "Thu, 7
	Jun 2007 12:23:04 +0000")
Message-ID: <87tztjo7zo.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+7b0XJt1mH4Ftl1LqP2LW/I9ZUm+Gw4FxstDt
 huLrTgwFKO5lmnm1qyu1AqvNSz9gMTgdO7+iybx67oEf7Wm4YT
 Yj0ZSskozwKetYMLe3UYQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

>> But either way the script never reaches "shutdown -rn now". So, it
>> seems, that my laptop does a full resume every other reboot, but it
>> never returns to userspace.
>
> But it returns to kernel... can you use more trace points to figure
> out where it hangs?

I haven't looked, but I guess this is somewhere in sysfs.

I made some small progress. With the nvidia.ko kernel module loaded,
my laptop returns to userspace. I'll investigate this further.

Regards, Olaf.
