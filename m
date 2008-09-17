Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYIQMeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYIQMeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 08:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYIQMdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 08:33:52 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:16694 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYIQMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 08:33:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZDrVMJiHBBrSMwQyxr0usZpbKOYSVqSk0uLz4xzkhqDEKcjD3aA20OFc9bQSmDUNOk
         vj9fXpOBppCTXVVmpi5hFxhA67ffJjRJphfQYbjLqdWtvgSRmhu8R8Nt24WEmlZppwY7
         /ZlJugnxBR3GFkjXUaIlA6cLD6iZKh49TFCvA=
Message-ID: <76366b180809170533t6962f3d0qf67278b2e9ff6bd0@mail.gmail.com>
Date: Wed, 17 Sep 2008 08:33:50 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: ACPI "Soft-off" power button only rebooting system, not powering off
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080917101809.GA4771@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180809162150o51701a1fk209af4e84ffc5674@mail.gmail.com>
	 <20080917101809.GA4771@elf.ucw.cz>
X-Google-Sender-Auth: 42ba6e8706a9a30e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 6:18 AM, Pavel Machek <pavel@suse.cz> wrote:
> On Wed 2008-09-17 00:50:03, Andrew Paprocki wrote:
>> I have an AMD / Award BIOS based system which does not properly shut
>> off when I hold down the power button for 4 seconds. The BIOS is
>> configured to have "Soft-off" set to "Delay for 4 seconds" which is
>> supposed to power the machine off if the button is held that long.
>>
>> I first thought this could be a BIOS bug, but this *only* appears to
>> happen while Linux is running. If the computer is running WinXP, it
>
> Well, so the BIOS is broken. 4second hold should power down the
> machine regardless of the operating system.

Yes, I agree.. I just find it strange that it works on the BIOS screen
as well as in GRUB, but as soon as Linux boots, it no longer works.
Since it works under WinXP, there must be some way to get it to work
properly from the OS side even it if means working around the bug
somehow.

-Andrew
