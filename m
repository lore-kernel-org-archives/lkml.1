Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXG3OZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXG3OZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbXG3OZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:25:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:23693 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762048AbXG3OZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QdBcjD3Avdpp03BrZmFf0a5ZuOIshkaWzcxPblTdwq0wgVGeMbUTpcraFPcJcHU0fDEMhunvPDw/CnyaexJ/6Rmyrs87ktMFWuRH8bWR/sIackAieOlhVPbwX1Jqw/6sSzswulL3IxhihB20ipCIQG7v1+LNZRaCjCNk0ena/RM=
Message-ID: <6bffcb0e0707300725i3bb8b677i75aeec6fed66bee2@mail.gmail.com>
Date: Mon, 30 Jul 2007 16:25:31 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: g3vbv@blueyonder.co.uk
Subject: Re: 2.6.23-rc1-git3 init failure
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46ABF0FA.8060301@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46ABF0FA.8060301@blueyonder.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sid,

On 29/07/07, Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
>  > Boot failure on x86_64 (64X2), says it can't find init, specifically
>  > /init. 2.6.23-rc1-git1 boots and runs successfully. I haven't tried
>  > -git2. I shall reboot on 2.6.23-rc1-git3 tomorrow and record the full
>  > message.
>  > Strings from vmlinux in both the above:-
>  >
>  > Kernel alive
>  > /dev/console
>  > <4>Warning: unable to open an initial console.
>  > <4>Failed to execute %s
>  > <4>Failed to execute %s.  Attempting defaults...
>  > /sbin/init
>  > /etc/init
>  > /bin/init
>  > /bin/sh
>  > No init found.  Try passing init= option to kernel.
>  >
>  > Tried option "init=/sbin/init" and got the same failure.
>  > Regards
>  > Sid.
>
> I see the sam problem with 2.6.23-rc1-git5.
>
> Freeing unused kernel memory: 236k freed
> failed to execute /init
> kernel panic - not syncing: No init found. Try passing init= option to
> kernel
>
> Copying /sbin/init to / results in the same error.
> openSUSE 10.3Alpha6plus
> # rpm -qf /sbin/init
> sysvinit-2.86-90

Please read chapter 4.1 and 4.5
http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf

It should be very simple

git-bisect start
git-bisect bad
git-bisect good 0de085bb474f64e4fdb2f1ff3268590792648c7b

and so on and so forth

>
> Regards
> Sid.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
