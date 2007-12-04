Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbXLDRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbXLDRA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXLDRAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:00:14 -0500
Received: from mx0.towertech.it ([213.215.222.73]:35793 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751331AbXLDRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:00:13 -0500
Date: Tue, 4 Dec 2007 17:59:51 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: rtc-linux@googlegroups.com, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Mike Frysinger" <michael.frysinger@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rtc-linux] Re: [PATCH 1/7] Blackfin RTC driver: the frequency
 function is in units of Hz, not units of seconds, so lock our driver down
 to 1 Hz
Message-ID: <20071204175951.6c47fee4@i1501.lan.towertech.it>
In-Reply-To: <8bd0f97a0712040856j530c1389l82adafcba07b89ae@mail.gmail.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
	<1195812512-25979-2-git-send-email-bryan.wu@analog.com>
	<20071204172634.50492e1e@i1501.lan.towertech.it>
	<8bd0f97a0712040829i116496deu384453c6eccfa252@mail.gmail.com>
	<20071204174146.19bedb54@i1501.lan.towertech.it>
	<8bd0f97a0712040847m73bb479dx814d83985e5223d5@mail.gmail.com>
	<20071204174947.5c468e3d@i1501.lan.towertech.it>
	<8bd0f97a0712040856j530c1389l82adafcba07b89ae@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 11:56:54 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On Dec 4, 2007 11:49 AM, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> > On Tue, 4 Dec 2007 11:47:56 -0500
> > "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > > the return of ENOTTY is to say "changing of freq isnt supported", not
> > > that the value is invalid.  but i can get the same behavior by
> > > deleting the function as the rtc-dev layer will take care of returning
> > > ENOTTY.
> > >
> > > so the behavior is for the RTC_IRQP_SET ioctl:
> > >  - return ENOTTY if you cannot change freq
> > >    - the rtc-dev layer will do this for you if you do not set irq_set_freq
> > >  - return EINVAL if the requested freq is not within the capabilities
> > > of the hardware
> > >
> > > sound about right ?
> >
> >  yes, it is. I agree about deleting it.
> 
> so, merge this patch and i'll follow up with another to delete the
> func and update the documentation ?

 ok. You have my 

 Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>

 on the whole patch set.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

