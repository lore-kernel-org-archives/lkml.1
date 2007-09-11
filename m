Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbXIKHrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbXIKHrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbXIKHrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:47:24 -0400
Received: from www.osadl.org ([213.239.205.134]:40150 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757920AbXIKHrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:47:23 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1189495400.25767.81.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <20070910144740.4eba2fda.akpm@linux-foundation.org>
	 <1189492636.25767.62.camel@chaos>
	 <20070911000001.30f8590b.akpm@linux-foundation.org>
	 <1189495400.25767.81.camel@chaos>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 09:47:20 +0200
Message-Id: <1189496840.22589.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > I went back to the original patch which I sent to Linus and it matches
> > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > must have been something else in the tree which I tested which fixed the
> > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > 
> > Can you think what would cause the symptoms which I described?  
> 
> It seems that time is not updated. Timer interrupt not active or some
> other odd thing. I figure out what's going on when I find a box which
> exposes the problem.

Can you please try the following command line options:

nolapic_timer
nohz=off
highres=off
nohz=off highres=off

	tglx


