Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbYDCPtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbYDCPtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757734AbYDCPs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:48:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbYDCPs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:48:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Didier Raboud <didier@raboud.com>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Thu, 3 Apr 2008 17:48:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200804021406.32668.didier@raboud.com> <200804031541.38493.didier@raboud.com>
In-Reply-To: <200804031541.38493.didier@raboud.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804031748.58113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of April 2008, Didier Raboud wrote:
> Le mercredi, 2 avril 2008 14.06:29 Didier Raboud, vous avez écrit :
> > Le mardi, 1 avril 2008 23.22:35 Rafael J. Wysocki, vous avez écrit :
> > > On Tuesday, 1 of April 2008, Didier Raboud wrote:
> > > > Le mardi, 1 avril 2008 23.11:15 Rafael J. Wysocki, vous avez écrit :
> > > > > (...)
> > > > > Can you please test the in-kernel hibernation, then?
> > > > >
> > > > > Rafael
> > > >
> > > > Hi,
> > > >
> > > > would like to. How ?
> > > >
> > > > # echo -n disk > /sys/power/state
> > >
> > > Yes, should work without the "-n", too.  Of course, you have to use the
> > > 'resume=' kernel command line argument for this to work.
> > >
> > > Perhaps increase the console log level before that.
> > >
> > > Thanks,
> > > Rafael
> >
> > Ok. I found a "better" way to do it : just uninstall uswsusp and let
> > kpowersave use hal to use suspend :-)
> >
> > Anyway, so far so good (with USB_SUSPEND not set), no hang. I will test
> > with USB_SUSPEND set and the incoming 2.6.25-rc8.
> >
> > Regards,
> >
> > Didier
> 
> So far so good too with "stock" Debian Kernel (2.7.25-rc7-amd64) with 
> USB_SUSPEND set. No hang.
> 
> The kernel suspend is less user-friendly than uswsusp though...
> 
> So I bet there is a bug in uswsusp's kernel part ?

It's almost the same as the in-kernel one, especially as far as the resume is
concerned.  The simplest explanation coming to mind is that the image is
somehow damaged in the uswsusp case.

You can use the uswsusp's checksumming to verify that, though.

Thanks,
Rafael
