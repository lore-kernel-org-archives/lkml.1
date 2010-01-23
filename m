Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130Ab0AWUHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0AWUHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717Ab0AWUHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:07:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43115 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0AWUHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:07:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device run-time PM (rev. 2)
Date: Sat, 23 Jan 2010 21:08:07 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.1001231018510.32358-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001231018510.32358-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001232108.07693.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 January 2010, Alan Stern wrote:
> On Sat, 23 Jan 2010, Rafael J. Wysocki wrote:
> 
> > Hmm, OK.
> > 
> > Of course, if the driver decides to leave disable_depth > 0, the user still
> > won't be able to do anything about that, but if I understand correctly, you
> > want drivers to have the option to use pm_runtime_forbid() initially, right
> > after pm_runtime_enable(), so that the user space can turn the runtime PM
> > on if desired via sysfs.
> > 
> > That makes sense.  I have a usage case for that myself. :-)
> > 
> > Updated patch is appended.
> 
> It looks good.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks!

Rafael
