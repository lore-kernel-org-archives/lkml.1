Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbXLDQme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbXLDQme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXLDQmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:42:08 -0500
Received: from mx0.towertech.it ([213.215.222.73]:55450 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751279AbXLDQmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:42:07 -0500
Date: Tue, 4 Dec 2007 17:41:46 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: vapier.adi@gmail.com, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
Subject: Re: [rtc-linux] Re: [PATCH 1/7] Blackfin RTC driver: the frequency
 function is in units of Hz, not units of seconds, so lock our driver down
 to 1 Hz
Message-ID: <20071204174146.19bedb54@i1501.lan.towertech.it>
In-Reply-To: <8bd0f97a0712040829i116496deu384453c6eccfa252@mail.gmail.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
	<1195812512-25979-2-git-send-email-bryan.wu@analog.com>
	<20071204172634.50492e1e@i1501.lan.towertech.it>
	<8bd0f97a0712040829i116496deu384453c6eccfa252@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 11:29:11 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> 
> On Dec 4, 2007 11:26 AM, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> > Bryan Wu <bryan.wu@analog.com> wrote:
> >
> >  Hi, I fannly got some time to review the patches. Seems ok, the
> >  only question is...
> >
> > > static int bfin_irq_set_freq(struct device *dev, int freq)
> > >  {
> > > -     struct bfin_rtc *rtc = dev_get_drvdata(dev);
> > >       stampit();
> > > -     rtc->rtc_dev->irq_freq = freq;
> > > -     return 0;
> > > +     return -ENOTTY;
> > >  }
> >
> >  .. why ENOTTY here?
> 
> blah, hit "reply" in previous e-mail ...
> 
> that's what the documentation says to do as does every other rtc driver ?
> -mike

 it should be EINVAL. at least it is wat rtc-cmos does when the value
 is invalid.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

