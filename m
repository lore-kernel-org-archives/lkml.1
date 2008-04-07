Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbYDGXMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYDGXMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYDGXMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:12:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58377 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbYDGXMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:12:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nikosapi <me@nikosapi.org>
Subject: Re: Suspend on Lenovo 3000 V200 - Linux 2.6.25rc8
Date: Tue, 8 Apr 2008 01:12:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <3e8fd0440804052010xbe8f59bw3268d8206b97ac3e@mail.gmail.com> <200804071934.42121.rjw@sisk.pl> <200804071859.24899.me@nikosapi.org>
In-Reply-To: <200804071859.24899.me@nikosapi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080112.50211.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of April 2008, nikosapi wrote:
> On April 7, 2008 13:34:41 Rafael J. Wysocki wrote:
> > On Monday, 7 of April 2008, nikosapi wrote:
> > > On April 7, 2008 04:58:37 Rafael J. Wysocki wrote:
> > > > On Monday, 7 of April 2008, nikosapi wrote:
> > > > > On April 6, 2008 19:23:36 Rafael J. Wysocki wrote:
> > > > > > On Monday, 7 of April 2008, nikosapi wrote:
> > > > > > > On April 6, 2008 16:21:57 Rafael J. Wysocki wrote:
> > > > > > > > On Sunday, 6 of April 2008, Nick Nobody wrote:
> > > >
> > > > [--snip--]
> > > >
> > > > > > > Hello Rafael,
> > > > > > >
> > > > > > > I tested with that patch and the problem persists, when the
> > > > > > > laptop resumes it locks up (with a black screen). If I add
> > > > > > > acpi_apic_instance=2 acpi_osi=Linux as kernel boot options (as
> > > > > > > suggested by my dmesg) when it resumes I get back to a virtual
> > > > > > > term but I'm not able to log in. After entering my username it
> > > > > > > just hangs there.
> > > >
> > > > Have you tried if doing "echo mem > /sys/power/state" instead of s2ram
> > > > works?
> > > >
> > > > If you have, what graphics adapter is there in your machine?
> > > >
> > > > Rafael
> > > > --
> > >
> > > Yes, I've been using /sys/power/state to put the machine to sleep ever
> > > since you told me.
> > >
> > > Here's the output of lspci -d 8086:2a02 -vvvxxx
> > >
> > > 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> > > Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
> >
> > Hm, Intel.  Do you use the i915 driver?
> >
> > Well, I think that what you see is another form of
> > http://bugzilla.kernel.org/show_bug.cgi?id=10319
> > so you can add yourself to the CC list in there.
> >
> > Thanks,
> > Rafael
> 
> Good news! I was reading through the linux-kernel archives and I found this[1] 
> post. It suggested using 2.6.25rc8-git2, I installed git4 and suspend works!
> 
> Thanks for your time, if you need anything else just ask.

Thanks for the update, I'm glad it started to work for you.

Rafael
