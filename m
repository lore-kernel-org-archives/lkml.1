Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYIRMM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYIRMM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 08:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYIRMMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 08:12:51 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:43785 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588AbYIRMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 08:12:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=J0Xnm/fqrRuk2r5JGGQccA+UfgHwK4AnE4jrmMmBYUf0fFq3n2GZZD4l9DV/VwXT;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <48D245BF.7060902@earthlink.net>
Date: Thu, 18 Sep 2008 08:12:47 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andrew Paprocki <andrew@ishiboo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI "Soft-off" power button only rebooting system, not	powering
 off
References: <76366b180809162150o51701a1fk209af4e84ffc5674@mail.gmail.com> <20080917101809.GA4771@elf.ucw.cz> <76366b180809170533t6962f3d0qf67278b2e9ff6bd0@mail.gmail.com> <20080918110635.GF27832@elf.ucw.cz>
In-Reply-To: <20080918110635.GF27832@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79e48d08d2c02203866b4590f645bbb448350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.77.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-09-17 08:33:50, Andrew Paprocki wrote:
>> On Wed, Sep 17, 2008 at 6:18 AM, Pavel Machek <pavel@suse.cz> wrote:
>>> On Wed 2008-09-17 00:50:03, Andrew Paprocki wrote:
>>>> I have an AMD / Award BIOS based system which does not properly shut
>>>> off when I hold down the power button for 4 seconds. The BIOS is
>>>> configured to have "Soft-off" set to "Delay for 4 seconds" which is
>>>> supposed to power the machine off if the button is held that long.
>>>>
>>>> I first thought this could be a BIOS bug, but this *only* appears to
>>>> happen while Linux is running. If the computer is running WinXP, it
>>> Well, so the BIOS is broken. 4second hold should power down the
>>> machine regardless of the operating system.
>> Yes, I agree.. I just find it strange that it works on the BIOS screen
>> as well as in GRUB, but as soon as Linux boots, it no longer works.
>> Since it works under WinXP, there must be some way to get it to work
>> properly from the OS side even it if means working around the bug
>> somehow.
> 
> Try noapic/nolapic/nosmp etc... and ask your vendor to fix the bios ;-).
> 
Why do you say it is the BIOS when it shuts down properly from the GRUB prompt 
or from in WINXP?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


