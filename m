Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXKBANP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXKBANP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXKBANA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:13:00 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:47329 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbXKBAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:12:59 -0400
Date: Thu, 1 Nov 2007 17:12:58 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &	CONFIG_VIDEO_SAA7146_VV=y
In-Reply-To: <20071101105738.GB28701@elte.hu>
Message-ID: <Pine.LNX.4.58.0711011707550.18400@shell2.speakeasy.net>
References: <20071026073736.GA24172@elte.hu> <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net>
 <20071101090142.GA13009@elte.hu> <Pine.LNX.4.58.0711010304490.18400@shell2.speakeasy.net>
 <20071101105738.GB28701@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Ingo Molnar wrote:
> > For some time now I've thought the whole ttpci config/makefile setup
> > sucked.  I've finally gone though and redone it and fixed this problem
> > too.
> >
> > Here is the patch: http://linuxtv.org/hg/v4l-dvb/rev/5320c2571183
>
> the drivers/media/dvb/ttpci/Kconfig bits do not apply:
>
>  $ q push
>  Applying patch patches/dvb-fix-5320c2571183.patch
>  patching file drivers/media/common/Kconfig
>  patching file drivers/media/dvb/ttpci/Kconfig
>  Hunk #1 FAILED at 1.
>  Hunk #2 FAILED at 63.
>  Hunk #4 FAILED at 99.
>  Hunk #5 FAILED at 120.
>  Hunk #6 FAILED at 142.
>  5 out of 6 hunks FAILED -- rejects in file
>  drivers/media/dvb/ttpci/Kconfig
>  patching file drivers/media/dvb/ttpci/Makefile
>  Patch patches/dvb-fix-5320c2571183.patch does not apply (enforce with -f)
>
> got a link to the dependent patch that i'm apparently missing?

These two:
http://linuxtv.org/hg/v4l-dvb/rev/5320c2571183
http://linuxtv.org/hg/v4l-dvb/rev/64935a44e510

Mauro will probably prepare a patch series to send to git soon that has this
stuff in it.
