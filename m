Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab0BZLJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:09:32 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:34473 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933799Ab0BZLJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d9gh/Jb7N34d0H1tRt4PQPeU6uFIgvbpvcOVXNTrhYq2H6nxSiL4YrocusXX96SYQh
         mvPWkAdTmaC/haX4j6CyxQJnV4SIs/ZCoJPkzE9so6jcVihV2ha9n+41vdU6EU/u+Qkc
         yww32qcTW2g9AcxJqNGFxjWQGrPCIlbUSzvzU=
MIME-Version: 1.0
In-Reply-To: <20100226115305.3dcc1f5a@neptune.home>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
	 <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
	 <20100226115305.3dcc1f5a@neptune.home>
Date: Fri, 26 Feb 2010 19:09:28 +0800
Message-ID: <45a44e481002260309of5b51c9t79302ec5fa132b9e@mail.gmail.com>
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>, linux-kernel@vger.kernel.org,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       FlorianSchandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org, jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 6:53 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> For me the driver would start with a default delay that matches the
> full-redraw throughput of the device but userspace could reduce the
> delay when it knows it will mostly just refresh small parts of the
> display (one or two tiles) and would like those done at a higher rate.

Who in userspace will know to reduce the delay? How will it know that
the delay should be reduced?

>
> A sample application would be displaying a media player interface
> like the one of XMMS and clones where Umeter (the part displaying
> volume per frequency range) could be refreshed ten times a second,
> the current position once a second and all the rest only on song
> change.

xmms/umeter will talk to this sysfs entry?

>
> Knowing the size of the display, probability that it's being used
> directly by X server is very small, it would rather be some application
> using it as a sideport display.
>

Yes, I'd like to know which applications these are.

Thanks,
jaya
