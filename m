Return-Path: <linux-kernel-owner+w=401wt.eu-S932361AbXHAPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbXHAPpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762516AbXHAPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:45:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762306AbXHAPpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:45:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: pm_trace displays the wrong time from the RTC
Date: Wed, 1 Aug 2007 17:54:25 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <46AFA78A.9010904@redhat.com> <200708011747.37932.rjw@sisk.pl>
In-Reply-To: <200708011747.37932.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011754.25903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 1 August 2007 17:47, Rafael J. Wysocki wrote:
> Sorry for slow response, I've just noticed this thread.
> 
> On Tuesday, 31 July 2007 23:20, Chuck Ebbert wrote:
> > When resuming, systems print this when booted on 07/31/07:
> > 
> > Date: 06/31/107
> > 
> > /drivers/base/power/trace.c::read_magic_time():
> > 114	get_rtc_time(&time);
> > 115	printk("Time: %2d:%02d:%02d Date: %02d/%02d/%02d\n",
> > 116		time.tm_hour, time.tm_min, time.tm_sec,
> > 117		time.tm_mon, time.tm_mday, time.tm_year);
> > 
> > include/asm-generic/rtc.h:
> > 102         /*
> > 103          * Account for differences between how the RTC uses the values
> > 104          * and how they are defined in a struct rtc_time;
> > 105          */
> > 106         if (time->tm_year <= 69)
> > 107                 time->tm_year += 100;
> > 108 
> > 109         time->tm_mon--;
> 
> Do you mean that systems display bad date after resuming if PM_TRACE is set,
> even if /sys/power/pm_trace contains 1 ?

s/1/0/ (sorry)
