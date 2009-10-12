Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZJLCd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZJLCd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 22:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZJLCd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 22:33:27 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:55600 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZJLCd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 22:33:27 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200910120232.n9C2Wlwb002087@clem.clem-digital.net>
Subject: Re: 2.6.32-rc4 fail compile -- drivers/char/rtc.c
To: xtfeng@gmail.com (Xiaotian Feng)
Date: Sun, 11 Oct 2009 22:32:46 -0400 (EDT)
Cc: clem@clem.clem-digital.net (Pete Clements),
       linux-kernel@vger.kernel.org (linux-kernel)
In-Reply-To: <7b6bb4a50910111837t7120e914p4d0796a826db7ba1@mail.gmail.com>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Xiaotian Feng
  > 
  > This may be caused by commit d43c36dc6b357fa1806800f18aa30123c747a6d1.
  > Can insert #include <linux/sched.h> into drivers/char/rtc.c fix this?

Yes, that clears the compile failure.

  > On Mon, Oct 12, 2009 at 8:26 AM, Pete Clements
  > <clem@clem.clem-digital.net> wrote:
  > > Fyi:
  > > (i386 SMP)
  > >
  > >
  > > =C2=A0CC =C2=A0 =C2=A0 =C2=A0drivers/char/rtc.o
  > > drivers/char/rtc.c: In function 'rtc_interrupt':
  > > drivers/char/rtc.c:271: error: 'TASK_INTERRUPTIBLE' undeclared (first use=
  >  in this function)
  > > drivers/char/rtc.c:271: error: (Each undeclared identifier is reported on=
  > ly once
  > > drivers/char/rtc.c:271: error: for each function it appears in.)
  > > drivers/char/rtc.c:273: error: 'SIGIO' undeclared (first use in this func=
  > tion)
  > > drivers/char/rtc.c:273: error: 'POLL_IN' undeclared (first use in this fu=
  > nction)
  > > drivers/char/rtc.c: In function 'rtc_read':
  > > drivers/char/rtc.c:362: error: implicit declaration of function '__set_cu=
  > rrent_state'
  > > drivers/char/rtc.c:362: error: 'TASK_INTERRUPTIBLE' undeclared (first use=
  >  in this function)
  > > drivers/char/rtc.c:376: error: implicit declaration of function 'signal_p=
  > ending'
  > > drivers/char/rtc.c:380: error: implicit declaration of function 'schedule=
  > '
  > > drivers/char/rtc.c:393: error: 'TASK_RUNNING' undeclared (first use in th=
  > is function)
  > > drivers/char/rtc.c: In function 'rtc_dropped_irq':
  > > drivers/char/rtc.c:1206: error: 'TASK_INTERRUPTIBLE' undeclared (first us=
  > e in this function)
  > > drivers/char/rtc.c:1208: error: 'SIGIO' undeclared (first use in this fun=
  > ction)
  > > drivers/char/rtc.c:1208: error: 'POLL_IN' undeclared (first use in this f=
  > unction)
  > > make[2]: *** [drivers/char/rtc.o] Error 1
  > > make[1]: *** [drivers/char] Error 2
  > > make: *** [drivers] Error 2
  > >
  > > --
  > > Pete Clements
-- 
Pete Clements 
