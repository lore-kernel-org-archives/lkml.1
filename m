Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZIWH0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZIWH0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZIWH0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:26:06 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:17439 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZIWH0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ahGXuJZz8UeSfylK8XlZ1+fHVMJQwJMGAUCy+yy9kVui7qXJSsXmEx+aAffu8FRRxW
         jsE0rrF+PDo9n2aRxBHqf+fON+cGlpZ9Peqo0xAvruBkunA+R/xr4xav//+iZrZmJdN5
         iAAlBmJGfS7S8m+qDo5MszSQfPVn1h16hielU=
MIME-Version: 1.0
In-Reply-To: <20090923071857.GC8565@elf.ucw.cz>
References: <1253590755.15763.21.camel@rzhang-dt> <4AB8C62F.5020605@cam.ac.uk>
	 <20090923071857.GC8565@elf.ucw.cz>
Date: Wed, 23 Sep 2009 09:26:07 +0200
Message-ID: <71cd59b00909230026x759bec26v767e40bf2d6b2737@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/2] introduce ALS sysfs class
From: Corentin Chary <corentin.chary@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       Len Brown <lenb@kernel.org>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 9:18 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2009-09-22 13:42:23, Jonathan Cameron wrote:
>> Zhang Rui wrote:
>> > Hi, Jonathan,
>> >
>> > this is the refresh ALS sysfs class driver.
>> > I just introduced one sysfs attribute "illuminance", because
>> > I didn't catch the exact meaning of the others like "???infrared".
>> > So it would be great if you can generate an incremental patch
>> > to introduce the other optional attributes needed, and update
>> > the documentation as well. :)
>> Will do, though may just leave it out of first pass of drivers
>> (as it may be controversial and it would be nice to get something
>> in place before the arguments begin!)
>>
>> All looks nice and clean. The only real question is whether
>> we want to standardize naming of devices under sysfs (like hwmon does)
>> or allow the individual drivers to do the naming?
>
> Allow the drivers to do the naming. Having useless name like "als0",
> with als0/name telling me what the driver is is bad.
>                                                                Pavel
>

This is how rfkill works, is there a good reason for that ? Should we
change that ?

-- 
Corentin Chary
http://xf.iksaif.net
