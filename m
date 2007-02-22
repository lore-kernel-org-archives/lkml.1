Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXBVUog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXBVUog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXBVUog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:44:36 -0500
Received: from smtp107.sbc.mail.re2.yahoo.com ([68.142.229.98]:29529 "HELO
	smtp107.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751874AbXBVUof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:44:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g7afJklM2GU05Q1RxJJ+yutzX/qG8rLBt6i23Jxnmenw2NI5nIy04Ke+v40v468BKe9WHWX8Oz/RnM1QQFweSfxgcdGod+loBSimKonsEfUpws4Mc9n2aY0PGWnKLPIo9gmWnw+0w5xn3EX7ZSI5RQ7NaE2ucNdrsbgyrdMvoo8=  ;
X-YMail-OSG: f6DTi70VM1mKGiFuhLAtqIryFUhxVX2zyDqiy0RGvc_Lqq972SPe7I9GNgsb_1EJ8a7UGcsEv9xCYeMLlYZlLQoki11DSRLgr5ZsjQOTenL7W7qYZxQt722wpDjQC7CsbW4cgLZOmIo8AyI-
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch/rfc 0/6] rtc framework: remove class_device, use class suspend()/resume()
Date: Thu, 22 Feb 2007 12:44:31 -0800
User-Agent: KMail/1.7.1
Cc: rtc-linux@googlegroups.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       john stultz <johnstul@us.ibm.com>
References: <200702211945.15003.david-b@pacbell.net> <20070222180941.GA15289@kroah.com>
In-Reply-To: <20070222180941.GA15289@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221244.32442.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007 10:09 am, Greg KH wrote:
> On Wed, Feb 21, 2007 at 07:45:14PM -0800, David Brownell wrote:
> > 
> > The main point of this series of patches is that last one, which I'll
> > circulate just a bit more widely.  (Although I think the first four are
> > also nice cleanups!)   It might be the first example of a framework that
> > uses the "new" class level suspend()/resume() calls to offload drivers.
> > 
> > ..
> 
> All of these looks good to me, feel free to add an:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to them if you want.

Thanks ...

 
> thanks for doing the class_device removal work, I appreciate it.

Actually the class_device removal work was because that was the
only way to clean the RTC suspend()/remove() patch out of my
queue, where it's been sitting since not log after those class
suspend/resume methods started to circulate, early last summer.

It'll be good to have that finally gone!

- Dave
