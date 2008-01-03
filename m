Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYACIWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYACIWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYACIWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:22:16 -0500
Received: from web95102.mail.in2.yahoo.com ([203.104.18.154]:32613 "HELO
	web95102.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753205AbYACIWP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:22:15 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 03:22:14 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=AYPFGi2lMV2bSb4UhideSFT0H2B8Rl3TFbuXNhAS8O2ka3JejYoTkesatAfS+iu3fONfBPpt1ugMZ0PAdBMmjyFICCNojqDk99EDvJSoVE8b4+Z3zd8gg10mWIBuu5usJvmBGS9oxl467LilmUM1ePm74fOvkGN3g1ruS32l9N8=;
X-YMail-OSG: R_CcIm4VM1lztMOus7ONrKqJmdxxaqe.kaWUtRQ0XsZyqU3O0Kn2mFahrR2XJpYPtGm.GIyg1amOs7Mq4uGO3DFoNr4NJOjGkiHtwkJflizqKIqqCs0-
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.158.1
Date: Thu, 3 Jan 2008 13:45:32 +0530 (IST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: Linux 2.6  KBUILD Help Required.
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <127978.95127.qm@web95102.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

          I have a one question.
          If I have to add  additional external flag on my external kernel module source during compilation with KBUILD.
          lest say I have one kernel module file hello.c
          and I want to add one flag -D testdebug.
         
        suppose this is my makefile.

obj-m += hello.o
all:
 make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
 make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

where I can add this flag.

Any help will be appreciated.

Thanks and Regards

----- Original Message ----
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
To: Sam Ravnborg <sam@ravnborg.org>
Sent: Wednesday, 28 November, 2007 11:30:59 PM
Subject: Re: Linux 2.6 kernel module compilation without using KBUILD


> Try disabling Module version support - then you do
> not
> see the .tmp_<modulename>.o
> When you have understood this simpler case you can
> move
> on and try enabling module versioning.
> 
> But again - you really do not need to understand all
> this
> kernel internal stuff to build a module.
> If your real goal is to build a module without
> use of kbuild you are on the wrong track.
> 
> Please enligthing us why you need all this deep
> internal
> knowledge to build your module and we may be able to
> tell
> you how to use kbuild top do so.
> 
> What you are heading at now looks like waste of time
> for all parties.
> 
>     Sam
>

Hello sam,

Thanks for your time.
Any way, we already had a lot discussion.
It just matter of interest nothing else.
Actually it is just a curiosity to know little bit 
Internals of KBUILD and module versioning.
You can say, it is my bad habit when I start work on
something.
I want to understand it from base.
Unfortunately this time I didn’t get much information
from google.
Neither from kernel documentation.
I don’t have any issue on using KBUILD.

Sorry again.
Thanks for your suggestion and view.

Murtuja Bharmal






      ____________________________________________________________________________________
Get easy, one-click access to your favorites. 
Make Yahoo! your homepage.
http://www.yahoo.com/r/hs


      Save all your chat conversations. Find them online at http://in.messenger.yahoo.com/webmessengerpromo.php
