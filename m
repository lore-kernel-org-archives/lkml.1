Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYFNJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYFNJfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYFNJfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:35:40 -0400
Received: from mx0.towertech.it ([213.215.222.73]:52355 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755460AbYFNJfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:35:39 -0400
Date: Sat, 14 Jun 2008 11:35:35 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Ingo Molnar <mingo@elte.hu>,
       Lior Dotan <liodot@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [rtc-linux] Re: [Bug 10866] /dev/rtc was missing until I
 disabled CONFIG_RTC_CLASS
Message-ID: <20080614113535.4d611e07@i1501.lan.towertech.it>
In-Reply-To: <200806131538.54254.david-b@pacbell.net>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	<200806131343.41213.david-b@pacbell.net>
	<20080613210257.GA529@elte.hu>
	<200806131538.54254.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 15:38:54 -0700
David Brownell <david-b@pacbell.net> wrote:

> 
> They can continue working just fine with *only* the legacy RTC.
> If they stuck with defaults, no problems appear.  (Modulo the
> fact that bitrot is setting in.)
> 
> The only thing that causes the least hiccup is someone who was
> for a while using a bogus (and non-default) configuration.
> 
> Given a bogus configuration, how should it be fixed?  There
> can be several solutions, and the right answer for one system
> will always be the right one for another.  So any approach
> that doesn't expect a human to select options sometimes will
> be inherently wrong in various cases.

 I agree with david. oldconfig cannot be made to fix every possible
 manual misconfiguration that has been introduced by the user, even
 those that, by chance, just worked.

 The actual Kconfig will handle pretty well the transition from
 a good config. where good is different from working-by-chance.

 There are far too many people that just keep pressing Y
 when a new kernel option appears without even considering what would
 happen or reading the help.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

