Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZILI1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZILI1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 04:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZILI1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 04:27:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47373 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZILI1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 04:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=vU3xCh2keLSlD7nGPYmC8yAIDXRLsihQN21NE72PxLd80gNCb/0gcML1mTWbb0CXGP
         Y8JLiOGJZID6Y6J+AQQPOGoNdIDD9l9MA70VDgwjnGtk0g/Oduv57DXyyK+KDJkTyfJg
         ozQa+d8goZxqzhbvFzc4AY6wicMRzMnWRqIg0=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Sat, 12 Sep 2009 10:27:08 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, LKML <linux-kernel@vger.kernel.org>
References: <200909112033.34445.volkerarmin@googlemail.com> <4AAB4FC9.4060402@arcor.de>
In-Reply-To: <4AAB4FC9.4060402@arcor.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909121027.08244.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Samstag 12 September 2009, Nikos Chantziaras wrote:
> (Volker stripped all CCs from his posts; I restored them manually.)

stripping is not entirely correct. marc does not list all recipients ;)
Thank you.

> 
> On 09/11/2009 09:33 PM, Volker Armin Hemmann wrote:
> > Hi,
> >
> > this is with 2.6.31+reiser4+fglrx
> > Phenom II X4 955
> >
> > KDE 4.3.1, composite temporary disabled.
> > tvtime running.
> >
> > load:
> > fat emerge with make -j5 running in one konsole tab (xulrunner being
> > compiled).
> >
> > without NO_NEW_FAIR_SLEEPERS:
> >
> > tvtime is smooth most of the time
> >
> > with NO_NEW_FAIR_SLEEPERS:
> >
> > tvtime is more jerky. Very visible in scenes with movement.
> 
> Is the make -j5 running niced 0? 

yes. It always is.


> If yes, that would be actually the
> correct behavior. 

maybe. But I do not complain about jerks at all. I have 

[ 3618.305918] hpet1: lost 1 rtc interrupts

with tvtime running since I switched cpus - so something is wrong anyway.

I just wanted to report that for _me_ the behaviour is worse with 
NO_NEW_FAIR_SLEEPERS and plain 2.6.31.

I tried it yesterday when the firefox update came in and I switched between 
NO_NEW_FAIR... and NEW_FAIR... several times and with NO_NEW_FAIR... tvtime 
was just _more_ jerky, I am not saying that it wasn't jerky without it nor do 
I complain about it at all. ;)

Glück Auf,
Volker
