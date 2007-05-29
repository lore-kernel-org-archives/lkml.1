Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbXE2MLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbXE2MLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXE2MLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:11:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXE2MLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:11:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael-Luke Jones <mike.luke.jones@gmail.com>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Tue, 29 May 2007 14:16:40 +0200
User-Agent: KMail/1.9.5
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <1179870110.16656.2.camel@localhost> <200705291400.46707.rjw@sisk.pl> <465C15D9.3070905@gmail.com>
In-Reply-To: <465C15D9.3070905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291416.42488.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 May 2007 14:00, Michael-Luke Jones wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday, 29 May 2007 08:55, Kay Sievers wrote:
> >> The shiny userspace firmware loading causes problems since it exists,
> >> every second box has problems with it, in all sorts of situations. If
> >> people are still sold to the idea of userspace firmware loading, why
> >> don't we keep the data in the driver, instead of immediately
> >> discarding it after the first upload? Not to waste a few hundred
> >> kilobytes? That doesn't sound like a convincing deal, after all the
> >> years people try to work around the issues it causes.
> > 
> > Agreed.
> > 
> > Rafael
> 
> Rather than most drivers being told to make this step, can this be added 
> to the firmware_class such that firmware objects are cached in RAM and 
> subsequent calls to request_firmware() don't have to query userspace.
> 
> This seems the least intrusive solution to this problem.

Agreed again. :-)

Greetings,
Rafael
