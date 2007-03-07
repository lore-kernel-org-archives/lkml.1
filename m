Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbXCGKK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbXCGKK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932868AbXCGKK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:10:59 -0500
Received: from smtp19.orange.fr ([80.12.242.1]:49926 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbXCGKK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:10:57 -0500
X-ME-UUID: 20070307101055649.9E8FD1C0009A@mwinf1902.orange.fr
From: Julien RF <julien.rf@no-log.org>
To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: PROBLEM: Crash on device_shutdown
Date: Wed, 7 Mar 2007 11:10:49 +0100
User-Agent: KMail/1.9.5
References: <200701290003.50918.julien.rf@no-log.org> <slrnes44am.m64.olecom@flower.upol.cz>
In-Reply-To: <slrnes44am.m64.olecom@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703071110.50553.julien.rf@no-log.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I still have the problem with 2.6.20.1 kernel :(
Julien

Le jeudi 01 février 2007 17:12, Oleg Verych a écrit :
> > From: Julien RF
> > Newsgroups: gmane.linux.kernel
> > Subject: PROBLEM: Crash on device_shutdown
> > Date: Mon, 29 Jan 2007 00:03:49 +0100
> > Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/487140>
>
> Hallo, Julien.
>
> Do you have such problem with more recent kernels, or mm one?
>
> Also, if would be good to have at least some of the stack trace.
>
> You can set up serial console for purpose of logging all information
> to remote host.
>
> > One line summary of the problem:
> > Crash on device_shutdown
> >
> >
> > Full description of the problem/report:
> > When I shut down the system, I get a crash on the device_shutdown
> > function (called by kernel_shutdown_prepare).
> > Since the bug happens when the system is almost shutted down, I can't get
> > the log...
> > I partially copied it by hand, ask me if you need further details :
> > Will now halt.
> > BUG: unable to handle kernel NULL pointer dereference at virtual adress
> > 00000128
> > ...
> > EIP is at device_shutdown + 0x49/0x6c
> > ...
> > Process halt
> > ...
> > /etc/rc0.d/S90halt: line 21: 11198 Segmentation fault halt -d -f
> > $shutdown $poweroff $hddown
> >
> > Julien Richard-Foy
>
> p.s. Please, care to honor "Mail-Followup-To" header information. Thanks.
> ____

