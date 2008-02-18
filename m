Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbYBRM4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbYBRM4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYBRM4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:56:42 -0500
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]:54805 "EHLO
	spaceymail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751185AbYBRM4l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:56:41 -0500
X-Greylist: delayed 21583 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2008 07:56:41 EST
Date: Tue, 19 Feb 2008 00:01:45 +1100
From: "Carlos E. M. Dyonisio" <cadu@nerdfeliz.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-Id: <20080219000145.ee2626fd.cadu@nerdfeliz.com>
In-Reply-To: <200802181227.28238.rjw@sisk.pl>
References: <200802172304.00322.rjw@sisk.pl>
	<20080218180201.6b3276d5.cadu@nerdfeliz.com>
	<200802181227.28238.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 12:27:27 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 18 of February 2008, Carlos Eduardo Medaglia Dyonisio wrote:
> > On Sun, 17 Feb 2008 23:03:59 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9960
> > > Subject		: [2.6.25-rc0 System no longer powers off after shutdown
> > > Submitter	: Frans Pop <elendil@planet.nl>
> > > Date		: 2008-02-11 16:23
> > > References	: http://lkml.org/lkml/2008/2/11/198
> > > Handled-By	: Greg KH <gregkh@suse.de>
> > > Patch		: http://lkml.org/lkml/2008/2/8/342
> > 
> > This bug is happening here too. I didn´t apply the patch yet (I´ll do it
> > when I get home), but if cpufreq is disabled, the system powers off
> > normally.
> > 
> > I´m using Linus´ git tree, commit 1309d4e68497184d2fd87e892ddf14076c2bda98.
> 
> Have you tried to apply the patch listed?

Yes, just tried. It works fine with SMP both enabled or disabled. I´m not
sure if removing that piece of code is the right thing to do though.

Cheers,
Carlos
-- 
Carlos Eduardo Medaglia Dyonisio
cadu@nerdfeliz.com
http://nerdfeliz.com/
