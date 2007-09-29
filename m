Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbXI2Qv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbXI2Qv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXI2Qvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 12:51:44 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:4911 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbXI2Qvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 12:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=h4/A2XwjRVlw+j79u4DGP2yCu0hSMFB9IzpVuygwkQcYpneuu0ggaNX4L16ovr5ieDS7wG+I/SRpnn5Rq3TDZKskR1TVf1kdXzmC4zJ6Qaki5F2cqUxh2qHG7JAi/mwku+EGOO0c9xIsCoRhvdPZUc7YtIOADoY22jJgyNutmgo=
Date: Sat, 29 Sep 2007 18:51:34 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8,
 v2.6.22.8, v2.6.21.7, v2.6.20.20
Message-ID: <20070929185134.4a76c80d@gmail.com>
In-Reply-To: <20070929022013.GA24496@khazad-dum.debian.net>
References: <20070926111357.GA10655@elte.hu>
	<20070928222631.25504d68@gmail.com>
	<20070929022013.GA24496@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 28 Sep 2007 23:20:13 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> escribió:

> On Fri, 28 Sep 2007, Alejandro Riveira Fernández wrote:
> >  I feel it better than 20.5 but the later is more stable. Let me explain.
> > 
> >  I patched a 2.6.22.9 kernel with both versions 22 and 20.5[1]. With the 22
> >  version if i lock the screen (run screensaver) or i try to run a wine program
> >  i experience a hard lock up no keyboard or mouse and i have to reboot the
> >  machine (i can not try to access it via ssh because i do not have a second
> >  machine).
> 

 Thanks for the response :D

> I have seen that twice with v20.5 under 2.6.22.7/.8. Didn't see it yet with
> v22.  xterm would get pissed if I tried to "secure keyboard", so something
> stole the keyboard focus and wouldn't give it back to xorg.  Maybe a locking
> bug in xorg somewhere?
> 
> Anyway, my kernel is NOT tainted, so rest assured that at least this one is
> not nVidia's fault.
> 
> BTW, v20.5 in 2.6.21.7 would sometimes cause dmcrypt to oops when first
> mounting a LUKS volume if there was some non-extra-light disk activity going
> on.  Probably something missing in the backport to 2.6.21...
> 
> Sorry, days down here have been very busy, so I didn't have time to send a
> proper bug report.

 I can add another data point 2.6.23-rc8-cfs-v22-g1bef7dc0-dirty does not have
 any problem with wine or xscreensaver is working fine. Again i use nvidia and
 a 3 party gpl driver for my wifi rt2500 which have compiled fine with the new
 kernel (surprise surprise!)
 If you need any more info just ask.
 
 Thanks

 P.S: I use ubuntu feisty fwiw


-- 
Nunca discutas con un idiota. Al final te hacen rebajarte a su nivel y entonces
te acaban ganando debido a su mayor experiencia.

