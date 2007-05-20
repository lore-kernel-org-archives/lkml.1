Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXETQYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXETQYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbXETQYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:24:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:46589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562AbXETQYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:24:01 -0400
From: Andreas Schwab <schwab@suse.de>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Ken Chen" <kenchen@google.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
References: <464F42F3.1080300@madrabbit.org>
	<2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	<3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
	<200705202002.53991.arvidjaar@mail.ru>
X-Yow: Well, here I am in AMERICA..  I LIKE it.  I HATE it.
 I LIKE it.  I HATE it.  I LIKE it.  I HATE it.  I LIKE it.
 I HATE it.  I LIKE..  EMOTIONS are SWEEPING over me!!
Date: Sun, 20 May 2007 18:23:44 +0200
In-Reply-To: <200705202002.53991.arvidjaar@mail.ru> (Andrey Borzenkov's
	message of "Sun\, 20 May 2007 20\:02\:52 +0400")
Message-ID: <jeodkfzcof.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov <arvidjaar@mail.ru> writes:

> On Sunday 20 May 2007, Kay Sievers wrote:
>>
>> Until the tools can request dynamic loop device allocation from the
>> kernel before they want to use the device, you can create as many as
>> needed "static" loop* nodes in /lib/udev/devices/, which will be
>> copied to /dev/ early on every bootup.
>>
>
> Won't these be removed after "losetup -d"?

No, only when you unload the loop module (and then only those that were
ever used).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
