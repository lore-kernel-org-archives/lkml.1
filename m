Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbXEZIIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbXEZIIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 04:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXEZIIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 04:08:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:23547 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbXEZIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 04:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZY7hrb2QBRVjIXDYdhpr/oRVMkLyXqbkywo47JFwEr+McEgf3ZtDniL9xyQ7SrCLGOPzoR0Bud5Zqok7E0vbTH54b72KoEYWElUu/NozPlAuKDR3/wE4UZ5ukZad2QZOF+6Xqadt3+oqiTVG+Upe5N+MMNtNbNKFZCHoElTAgMo=
Message-ID: <2bd9ebfa0705260108t67f33613p1e31683741c7507@mail.gmail.com>
Date: Sat, 26 May 2007 04:08:39 -0400
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: reg: modules make in Ubuntu
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070526065835.GA22020@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2bd9ebfa0705252228u65b62ddbta2337ce56e77618a@mail.gmail.com>
	 <20070526065835.GA22020@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, May 26, 2007 at 01:28:56AM -0400, Tej Parkash wrote:
> > make[1]: Entering directory `/usr/src/linux-headers-2.6.20-15-generic'
> >  CHK     include/linux/version.h
> >  CHK     include/linux/utsrelease.h
> > make[2]: *** No rule to make target `arch/i386/kernel/msr.c', needed
> > by `arch/i386/kernel/msr.o'.  Stop.
> > make[1]: *** [arch/i386/kernel] Error 2
> > make[1]: Leaving directory `/usr/src/linux-headers-2.6.20-15-generic'
> > make: *** [all] Error 2
> >
> > what the hack is this. no kernel version is having this file in this
> > particular location as asked in error. then why this error is coming
> > in this kernel version.
> Looks like you are trying to build a kernel but have only headers
> judging from the directoryname.
yaa u r correct
but i am wondering like how those file can be missed from the required
location. if they are so important to build the module.. even if it is
missed is there any other procedure to build the module
i am trying it on other kernel version.

>
> Could you please prove a bit more context if you need additional help.
> Like (but not limited to):
> -> Actual commandline
> -> Any own kbuild/Makefiles
> -> .config
>
>         Sam
>
thanks
tej
