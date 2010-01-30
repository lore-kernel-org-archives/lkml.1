Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292Ab0A3T5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0A3T5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588Ab0A3T5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:57:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab0A3T5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:57:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Regressionhung task during raid rebuild 2.6.33 rc5 was: Re: 2.6.33RC3 hung task - jbd2/dm-1-8 (during raid rebuild)
Date: Sat, 30 Jan 2010 20:57:59 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4B4A4AD7.5090800@majjas.com> <4B6486A7.8030404@majjas.com>
In-Reply-To: <4B6486A7.8030404@majjas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001302057.59529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 January 2010, Michael Breuer wrote:
> On 1/10/2010 4:47 PM, Michael Breuer wrote:
> > System crashed (watchdog reset).
> >
> > Was doing a raid rebuild at the time (raid6).
> >
> > I typed, 'yumdownloader --source virtlib' ... system froze, then 
> > rebooted on the watchdog reset.
> >
> > I've attached the log extract from the event as well as dmesg.
> >
> >
> Hit this again - system doesn't crash now - just get the hung task 
> warning (log extract attached). System seems to keep running (albeit the 
> rebuild is incredibly slow on 2.6.33 rc5 - approx 6500K/sec vs. about 
> 80,000K/sec on 2.6.32.4.
> 
> Looks like it may be triggered by disk io during the rebuild. This time 
> I had typed, "sync." "sync" hung for a long while but did eventually 
> complete.

Is this the bug tracked as http://bugzilla.kernel.org/show_bug.cgi?id=15125 ?

Rafael
