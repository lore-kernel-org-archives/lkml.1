Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZIVF6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZIVF6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZIVF6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:58:40 -0400
Received: from mail.ijs.si ([193.2.4.66]:51322 "EHLO mail.ijs.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbZIVF6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:58:39 -0400
Message-Id: <5.1.0.14.2.20090922075153.00be9690@pop3.arnes.si>
X-Mailer: QUALCOMM Windows Eudora Version 5.1
Date: Tue, 22 Sep 2009 07:59:14 +0200
To: Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>
From: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments 
  amc6821 chip
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
In-Reply-To: <20090921144423.6ebf564f.akpm@linux-foundation.org>
References: <20090909093435.60531d95@hyperion.delvare>
 <20090905_120834_010267.tomaz.mertelj@guest.arnes.si>
 <20090908170649.855dd1ff.akpm@linux-foundation.org>
 <20090909093435.60531d95@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 14:44 21. 9. 2009 -0700, Andrew Morton wrote:
>On Wed, 9 Sep 2009 09:34:35 +0200
>Jean Delvare <khali@linux-fr.org> wrote:
>
> > > #define set_temp_para(name, reg)\
> > > static ssize_t set_##name(\
> > >             struct device *dev,\
> > >             struct device_attribute *attr,\
> > >             const char *buf,\
> > >             size_t count)\
> > > {\
> > >     return set_helper(dev, attr, buf, count, &dev->name);\
> > > }
> > >
> > > And then do all the real work in a common function?  Rather than
> > > expanding tens of copies of the same thing?
> >
> > Yes please. We got rid of macro-generated callbacks in most hwmon
> > drivers a couple years ago already.
>
>I never received an update to this patch so I'm retaining it in my tree
>for now.


OK. I have an update almost ready. I only need some time to test it.

Should I post a patch on top of the original patch or a full patch to the 
latest kernel tree?

Tomaz Mertelj


***********************************************************************************
Tomaz Mertelj
E-mail: tomaz.mertelj@guest.arnes.si    Home page: 
http://optlab.ijs.si/tmertelj


Staniceva 14
1000 Ljubljana
Slovenia
***********************************************************************************



