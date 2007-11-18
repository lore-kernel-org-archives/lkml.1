Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbXKROqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbXKROqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 09:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXKROqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 09:46:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34690 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXKROqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 09:46:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Date: Sun, 18 Nov 2007 16:03:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org> <200711181442.09917.rjw@sisk.pl> <474043EC.4000700@gmail.com>
In-Reply-To: <474043EC.4000700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181603.26522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of November 2007, Jiri Slaby wrote:
> On 11/18/2007 02:42 PM, Rafael J. Wysocki wrote:
> > On Sunday, 18 of November 2007, Jiri Slaby wrote:
> >> On 11/18/2007 01:42 PM, Jiri Slaby wrote:
> >>> See shot of prints here:
> >>> http://www.fi.muni.cz/~xslaby/sklad/susp_hang1.png
> >> BTW output from that tree minus the patch:
> > 
> > Hm, it looks like one of the CPU hotplug notifiers is doing something wrong.
> > 
> > Can you try to see what happens (with the patch applied) if
> > thermal_throttle_cpu_callback() is not registered?
> 
> After commenting out
> //device_initcall(thermal_throttle_init_device);
> it looks like this:
> http://www.fi.muni.cz/~xslaby/sklad/susp_hang2.png

Can you also make the new System-map available, please?
