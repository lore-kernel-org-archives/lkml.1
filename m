Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbXFAXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbXFAXRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXFAXQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:16:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58070 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbXFAXQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:16:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Greaves <david@dgreaves.com>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression
Date: Sat, 2 Jun 2007 01:22:49 +0200
User-Agent: KMail/1.9.5
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com>
In-Reply-To: <46609FAD.7010203@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706020122.49989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 2 June 2007 00:37, David Greaves wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 1 June 2007 23:23, David Greaves wrote:
> >> Not a regression though, it does it in 2.6.21
> >>
> >> If I cause the system to save state to disk then whilst off it no longer
> >> responds to g-wol.
> > 
> > Can you please try with the hibernation and suspend patch series from
> > 
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/
> > 
> > applied?
> > 
> > Greetings,
> > Rafael
> > 
> 
> Sorry I made a mistake in the report.
> I was still booting 2.6.21.1 - very sorry :(
> 
> The real situation is worse :(

Ouch.
 
> 2.6.22-rc3 (no patches) just hangs on suspend at:
> Suspending consoles
> 
> console switching works but needs a hard reset to reboot.
> 
> 2.6.22-rc3-skge (with Rafael's patches)
> suspends to disk and powers off
> wol doesn't work incidentally
> resume resumes to the exact same place that 2.6.22-rc3 hangs at...
> ie a non-responsive system saying
> Suspending consoles
> 
> Note, in both cases I can switch VTs, the caps/numlock lights respond.

Can you set CONFIG_DISABLE_CONSOLE_SUSPEND in .config and see where exactly it
fails?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
