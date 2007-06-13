Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXFMT5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXFMT5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXFMT5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:57:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:60849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbXFMT5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:57:00 -0400
From: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz>
Date: Wed, 13 Jun 2007 21:56:57 +0200
Message-ID: <87fy4vmxva.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1/IwmlBYDG/KmyPwBoq5r0FaEYbL8jl8E0Jrx2
 Y/YorreKZDsEEaIpBu1J3qXUf37mL7Tv/FCP/DZlfb9+G7neuD
 6myaJeyXXhLtFVYI0Wn8w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

>> resume from suspend to ram doesn't work for my laptop and never
>> has. So, this is not a regression.
[...]
> Beeping patch? It is in -mm now. noapic nolapic and nosmp are useful,
> too.

With the proprietary nvidia module, the laptop resumes, but the screen
stays black. Meanwhile I tested the nvidiafb module, with identical
results: machine comes back from suspend, but with a black screen. Now
I cann ssh into it and do a proper shutdown or whatever. This is of
course nonsatisfying and I'm still playing around.

I haven't tested noapic, nolapic so far. This is a UP kernel.

Regards, Olaf.
