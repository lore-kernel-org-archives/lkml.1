Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0BHTb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:31:56 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41722 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0BHTby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oBOu4ItJHpCSYreXeL1B4h17yflmJJwrPrfXtlAmpiLs4PprDA6BfAK7Og8NLJCVwi
         zC3eDdNNWBadEug2bePv7Vj6du+DouzcK9rPKc4vXuJP3jWnA1/yoqmB8dz2vTyFwsIv
         KKlfcIm/YcTMZBvtGmzz3bCypHAGsMUiHMbp8=
MIME-Version: 1.0
In-Reply-To: <201002082022.43515.rjw@sisk.pl>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <4B7004F4.3030804@canonical.com>
	 <b170af451002080438i18a1e541x8dc038f4b5f129f4@mail.gmail.com>
	 <201002082022.43515.rjw@sisk.pl>
Date: Mon, 8 Feb 2010 20:31:52 +0100
Message-ID: <b170af451002081131t6d77c808tb512b01c975a4c3e@mail.gmail.com>
Subject: Re: [Bug #15096] Resume lock up -- bisected, commit 
	3a1151e3f124fd1a2c54b8153f510f1a7c715369
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stefan Bader <stefan.bader@canonical.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 8 lutego 2010 20:22 użytkownik Rafael J. Wysocki <rjw@sisk.pl> napisał:
> On Monday 08 February 2010, Rafał Miłecki wrote:
>> 2010/2/8 Stefan Bader <stefan.bader@canonical.com>:
>> > Rafael J. Wysocki wrote:
>> >> On Monday 08 February 2010, Rafał Miłecki wrote:
>> >>> 2010/2/8 Rafael J. Wysocki <rjw@sisk.pl>:
>> >>>> This message has been generated automatically as a part of a report
>> >>>> of regressions introduced between 2.6.31 and 2.6.32.
>> >>>>
>> >>>> The following bug entry is on the current list of known regressions
>> >>>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> >>>> be listed and let the tracking team know (either way).
>> >>>>
>> >>>>
>> >>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15096
>> >>>> Subject         : Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
>> >>>> Submitter       : Rafał Miłecki <zajec5@gmail.com>
>> >>>> Date            : 2010-01-20 23:15 (19 days old)
>> >>>> First-Bad-Commit: http://git.kernel.org/git/linus/3a1151e3f124fd1a2c54b8153f510f1a7c715369
>> >>
>> >> It looks like we should revert this commit, seems broken.
>> >
>> > Hm, otoh we had definitely people with some Asus laptops who where only be able
>> > to use backlight control with it. So I would rather prefer some work around to
>> > the suspend/resume problem (_DOS if I understood correctly).
>>
>> It's same case with my Sony VAIO. Without this I can not control
>> backlight. Eventually I can hack on GPU registers directly, but I
>> don't think it can be called solution.
>
> Well, do I understand correctly that without commit
> 3a1151e3f124fd1a2c54b8153f510f1a7c715369 you can't control the backlight,
> but with the commit applied there's a resume problem on your box?

That's right.
BEFORE: no backlight controll, resume works fine
AFTER: backlight control, resume locks up machine

-- 
Rafał
