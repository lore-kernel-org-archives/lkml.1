Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZKLIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZKLIIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZKLIIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:08:34 -0500
Received: from web58403.mail.re3.yahoo.com ([68.142.236.171]:33529 "HELO
	web58403.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751673AbZKLIId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:08:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=qJVe6tgBrpXkXClOq1G0SU5DvBXBq0IItHDlMdzoyH1Do8sC1Xw2/7sqpVAUTJVuUUJZcuwTtDKomFWmHX6BufzOKS/WF1oE2QiBSW04KGvEHmhxC63GuY8VQ/Wl9bH6T9ysX9Q5TDzgMH9cr502+WJ43a872KJBUWgHTvq3SEI=;
Message-ID: <282630.26689.qm@web58403.mail.re3.yahoo.com>
X-YMail-OSG: edc8ZEgVM1nr7AaVeLhWNyVtm8EINAy9sEo0i7RWkQj8zxWA2esQRldU6.X6U3UAPiRN4QT8VxAtmKDbvJDOQgMQVhqP9SyM_gzBr1MgN1DhTZ8idj6Rzpd_Qi.o9H6_rGfD46XmfwovPczdE3ULXAxvebBtY_E54Y._SHJA3drrGw0NEJLsTd4.mliYWfY4cF9Ko9.xe0n2_FWiX547TH_aEUxCYmXk4cUN_v.NKAwP2U0GkqpJVpxLj.bEcGXAi_vcw4mZCMctlSu..Bm7bhwpHXUCc6VmEkzu
X-Mailer: YahooMailRC/211.6 YahooMailWebService/0.7.361.4
References: <761296.29412.qm@web58402.mail.re3.yahoo.com> <20091111095218.GA3654@core.coreip.homeip.net> <800885.42568.qm@web58401.mail.re3.yahoo.com> <20091111215029.GA13390@core.coreip.homeip.net>
Date: Thu, 12 Nov 2009 00:08:39 -0800 (PST)
From: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: keyboard leds not restored after s2ram in 2.6.32-rc6-00166-g799dd75
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091111215029.GA13390@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> > I did some tests suspending with the caps lock actually on, and it seems that
> > in that case the user might still be confused (caps lock is on but led is 
> off).
> > At least on this machine this patch doesn't affect this theoretical problem
> > either way (2.6.31 behaves similarly), so it is ok.
> > 
> 
> Umm... so you are saying that even with .31 if you suspend with capslock
> on it is off when you resume? Does it happen only in X or in console as
> well?

It seems I judged a bit too early.
In console, both 2.6.31 and .32-rc6+your patch:
- suspending both with capslock on and off works as expected (same state in mode
and led after resume)

In X, both  2.6.31 and .32-rc6+your patch:
- suspending both with capslock on and off works; after resume same state
(typing procudes capital letters if capslock was on) and led shows the caplock
state
- if the capslock is on after resume, and I press shift before capslock key, the led
turns off but typing still produces capital letters. This, I think, is strange. This did
not happen in console, neither does pressing shift usually turn off the led.

So, apart from the minor nuisance of the shift key turning off the capslock led in X
even if typing still produces capital letters, everything seems to work as expected.


Mikko


> 
> -- 
> Dmitry



      
