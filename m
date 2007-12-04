Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbXLDQ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbXLDQ3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXLDQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:29:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:53442 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXLDQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:29:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ldY42k7nxXMgVpZ5bnlfsVrF+yRuyPKEQmIL9Kt9jsOgiQIKGSai/f67W1uJ1zmwVs/ieESYrWR3GuakfDHR/HzH8ldl4hHt30akNY7xxpIKiM1Kld6R2QtnqN0oEFOo+RBjTwTMj1O8WJPbj0J2MI6NLo7XyG4aYcBgnHoukHw=
Message-ID: <8bd0f97a0712040829i116496deu384453c6eccfa252@mail.gmail.com>
Date: Tue, 4 Dec 2007 11:29:11 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: rtc-linux@googlegroups.com
Subject: Re: [rtc-linux] Re: [PATCH 1/7] Blackfin RTC driver: the frequency function is in units of Hz, not units of seconds, so lock our driver down to 1 Hz
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <20071204172634.50492e1e@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
	 <1195812512-25979-2-git-send-email-bryan.wu@analog.com>
	 <20071204172634.50492e1e@i1501.lan.towertech.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 11:26 AM, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> Bryan Wu <bryan.wu@analog.com> wrote:
>
>  Hi, I fannly got some time to review the patches. Seems ok, the
>  only question is...
>
> > static int bfin_irq_set_freq(struct device *dev, int freq)
> >  {
> > -     struct bfin_rtc *rtc = dev_get_drvdata(dev);
> >       stampit();
> > -     rtc->rtc_dev->irq_freq = freq;
> > -     return 0;
> > +     return -ENOTTY;
> >  }
>
>  .. why ENOTTY here?

blah, hit "reply" in previous e-mail ...

that's what the documentation says to do as does every other rtc driver ?
-mike
