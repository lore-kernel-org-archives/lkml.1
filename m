Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZJBT3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZJBT3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZJBT3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:29:22 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:35486 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZJBT3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q36l4f1MrcLgL4ox6nsyeWctbMoSAu/d0f42mOdovC3cjBhFmQb1Pd3ZJMB8DJsMDp
         98vzqepGE8bj6CYMh9hOQZzGt2/q5BC8xefrTnHZJpX4RtMERaQC4Rwms5GNBgoc0n2B
         qEfMDbiv/3wb94Q2cRcslRmqRTFt1Eq3PZLHI=
MIME-Version: 1.0
In-Reply-To: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com>
References: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com>
Date: Fri, 2 Oct 2009 15:29:24 -0400
X-Google-Sender-Auth: 5828ef4c6cd79cb3
Message-ID: <cb0375e10910021229x7924ec56o61627ec0f625a70c@mail.gmail.com>
Subject: Re: High power consumption after suspend/resume cycle
From: Andrew Lutomirski <luto@mit.edu>
To: linux-kernel@vger.kernel.org, linux-thinkpad@linux-thinkpad.org
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding cc's to linux-pm and linux-acpi and ]

On Fri, Oct 2, 2009 at 1:44 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> Hi all-
>
> I'm running a git kernel that's slightly newer than 2.6.32-rc1.
>
> First, thanks for all the great work everywhere on laptop power
> consumption -- on my Lenovo X200s, it looks like Linux is getting
> close to Windows (Windows wins by about 0.7W, except that its power
> usage frequently spikes since Windows apparently still doesn't know
> how to sit still and do nothing, whereas Linux's seems more stable.),
> even running KDE with compositing enabled and
> while connected to wifi, at least after some tweaking.

[fixed irrelevant typo above, too.]

>
> There's a catch, though: after a suspend/resume cycle, power
> consumption goes up by over well over a watt.  (On a system that draws
> about 7 watts before suspending, that's a big deal.)  I've tried
> turning off X, suspending with 'echo mem > /sys/power/state' to avoid
> any distro scripts running, and manually restoring SATA power saving
> settings, but it still happens.  I even tried unbinding e1000e and
> both USB drivers, unloading the i2400 (wimax) driver, iwlagn, and
> iwlcore, and it still happens.  This is 100% reproducible, and I'd be
> happy to test things.
>
> This could be a BIOS bug I suppose (although I'm running the latest
> BIOS), but Windows 7 does not have this problem at all.
>
> Any ideas about what to try or what subsystem to blame?
>
> I'm running Fedora 11 if that makes any difference.

This is actually more like 90% reproducible.  I've gotten it to stay
in low power after suspend a couple times with HAL disabled, but I
can't reliably reproduce *that*, either.

>
> Thanks,
> Andy
>
