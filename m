Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZHRNXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZHRNXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbZHRNX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:23:29 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36956 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbZHRNX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uUwSVhflKeFDEW5DgTz+JiUWA2peNaLoTNtWhCBHuocHcmXYEH78tedaP/Uj46Yy33
         0i3/Q4bPPbl3cNCBOcsTKcA7giK4C3y1eLaHDvz9GUBEf58f5DbliOG0Uvj8aM6zzrZ9
         dPHBi3cV8RrwDoiz8xJ+GSRbW0ux6Lb/+UzLM=
MIME-Version: 1.0
In-Reply-To: <1250589285.5150.1.camel@localhost.localdomain>
References: <4A89E76B.5070204@dell.com>
	 <9b2b86520908180143t4b25c1f7hd78cd4b4333c4ab4@mail.gmail.com>
	 <1250589285.5150.1.camel@localhost.localdomain>
Date: Tue, 18 Aug 2009 14:23:29 +0100
Message-ID: <9b2b86520908180623i4e7ce5cv9a4cd6b1704a0e5f@mail.gmail.com>
Subject: Re: [PATCH 3/3] Drop platform sysfs support
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Mario Limonciello <mario_limonciello@dell.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, cezary.jackiewicz@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/09, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Alan,

>> In practice I suspect it makes no difference that the rfkill and
>> backlight devices are exported as virtual devices with no physical
>> parent.  I just don't think it's "right" :-).
>
> it actually does make a difference for hardware detection. We wanna have
> them hanging of the compal platform device.

Ok.  I wasn't sure that userspace was allowed to rely on that, but I
re-read Documentation/ABI/testing/sysfs-devices and I see now that it
can be allowed.

Some of these issues with the compal-laptop work may come from copying
dell-laptop.  dell-laptop is the only driver which creates rfkill
devices without a parent device.  In fact, it doesn't even create a
platform device :-).

I'll try sending a patch or two to clean up dell-laptop.  I don't have
the hardware but it should be pretty mechanical, almost a copy+paste
job from a "good" driver.

Thanks
Alan
