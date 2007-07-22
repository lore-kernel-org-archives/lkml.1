Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbXGVE4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbXGVE4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 00:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXGVE4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 00:56:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:40209 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbXGVE4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 00:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CWO1ExmvRGJ576SdBZqlraqEmrk8zMkFTwz3+Sp4HVm4QMxN3JTjQpA+Vls/ZffmvxfgkJih5LAiPY6M5xyAuoKOJLovApVd+4aDk853oyfDGYXxWVZbHB+qCv5vY0Sn05vancpFnaEm/XEWXr9ojGuSKXlxv8LZnko7fMM1xwI=
Message-ID: <c96265a60707212156v5cfad301q8c3d75bf65863048@mail.gmail.com>
Date: Sat, 21 Jul 2007 21:56:00 -0700
From: "Mark Tiefenbruck" <mark@fluxbox.org>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Dell Inspiron 1501 fails to boot in 2.6.21+
In-Reply-To: <1185017631.4012.111.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
	 <1185017631.4012.111.camel@chaos>
X-Google-Sender-Auth: 06f3dcc887e889ad
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you please try the following command line options in any
> combination:
>
> hpet=disable
> nohz=off
> highres=off
> nolapic_timer

I've now tried running the kernel with all combinations of
hpet=disable, nolapic_timer, and clocksource=pm_timer|acpi_pm. I feel
like hpet=disable was probably unnecessary, since I have HPET disabled
in my BIOS. I didn't bother with nohz and highres=off, since I don't
believe those options are present in the version of the kernel I'm
testing. None of these made any difference, but I can try the rest of
the combinations, if you think I should. Just to make sure, I should
be placing these after the kernel path in grub.conf, right?

I noticed during these tests that the cursor still blinks when it
reaches the point where it stops printing things. This seems like good
evidence that, indeed, the kernel is still active but is waiting for a
response. Or maybe the hardware does that itself.

I checked on what happens when I enable HPET in my BIOS. In the
working kernel, it gets to the boot scripts and stops doing anything
useful when letting udev process events. With the newer kernels, it
halts in the same place as before.

So, what next? I am of course willing to give out reasonable
information about my system and try out patches.

  Mark
