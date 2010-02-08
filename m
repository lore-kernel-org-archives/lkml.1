Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0BHTbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:31:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:17046 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0BHTbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mc9cOx9fE4FfAYKkGKADO189ap5UcgGXGobT7XAVEVvU8Mo1CoAJISo3EhCeFwVDKR
         kfqzTpca2aqBwEry0sxJdYj6w9SMU9xKtOPStH3nfPrOeDZ6glUgbWA+eMoUzM2mC9Sy
         TEQukNkzsfheFYYOQG9pKM1SiypMdDMhNQZ20=
MIME-Version: 1.0
In-Reply-To: <201002082024.32483.rjw@sisk.pl>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <201002081156.24020.rjw@sisk.pl>
	 <b170af451002080349x4fb955b2wb9d0bdf6e6e03d0e@mail.gmail.com>
	 <201002082024.32483.rjw@sisk.pl>
Date: Mon, 8 Feb 2010 20:31:09 +0100
Message-ID: <b170af451002081131w6f1e185epc4e0c13323b75934@mail.gmail.com>
Subject: Re: [Bug #15096] Resume lock up -- bisected, commit 
	3a1151e3f124fd1a2c54b8153f510f1a7c715369
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Len Brown <len.brown@intel.com>,
       Stefan Bader <stefan.bader@canonical.com>,
       Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 8 lutego 2010 20:24 użytkownik Rafael J. Wysocki <rjw@sisk.pl> napisał:
> On Monday 08 February 2010, Rafał Miłecki wrote:
>> W dniu 8 lutego 2010 11:56 użytkownik Rafael J. Wysocki <rjw@sisk.pl> napisał:
>> > On Monday 08 February 2010, Rafał Miłecki wrote:
>> >> 2010/2/8 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> > This message has been generated automatically as a part of a report
>> >> > of regressions introduced between 2.6.31 and 2.6.32.
>> >> >
>> >> > The following bug entry is on the current list of known regressions
>> >> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> >> > be listed and let the tracking team know (either way).
>> >> >
>> >> >
>> >> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15096
>> >> > Subject         : Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
>> >> > Submitter       : Rafał Miłecki <zajec5@gmail.com>
>> >> > Date            : 2010-01-20 23:15 (19 days old)
>> >> > First-Bad-Commit: http://git.kernel.org/git/linus/3a1151e3f124fd1a2c54b8153f510f1a7c715369
>> >
>> > It looks like we should revert this commit, seems broken.
>> >
>> > Anyway, I'll do my best to have a look at this bug later today.
>>
>> In such case I'd prefer to add "broken_DOS" flag for devices that were
>> enabled by this patch. We could avoid restoring backlight on resume
>> for broken_DOS then and maybe just update brightness to current value.
>
> Or perhaps we can try to restore the backlight at a different place.

I wanted to find out what causes this lock up by syncing modules
resume or putting some delays. See bug report of my question.
Unfortunately didn't get answer.

-- 
Rafał
