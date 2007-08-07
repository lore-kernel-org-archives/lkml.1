Return-Path: <linux-kernel-owner+w=401wt.eu-S934725AbXHGUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725AbXHGUcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbXHGUbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:31:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbXHGUbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:31:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Tue, 7 Aug 2007 22:41:23 +0200
User-Agent: KMail/1.9.5
Cc: "Michael Sedkowski" <sedmich@gmail.com>, trenn@suse.de,
       "Tejun Heo" <htejun@gmail.com>, "Robert Hancock" <hancockr@shaw.ca>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <8db1092f0708071309h5cf6f68bo80b44d9a2fbeabeb@mail.gmail.com> <200708072233.52500.rjw@sisk.pl>
In-Reply-To: <200708072233.52500.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708072241.24091.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 August 2007 22:33, Rafael J. Wysocki wrote:
> On Tuesday, 7 August 2007 22:09, Maciej Rutecki wrote:
> > 2007/8/7, Michael Sedkowski <sedmich@gmail.com>:
> > > I did some additional checking today...
> > > On kernels prior to 2.6.22 line, the bug exists and manifests itself
> > > exactly the same way. However, when I removed the "-h" flag
> > > from /etc/init.d/halt, the drive spins down only once on "Power down"
> > > message and there is no sign of the bug and the emergency unload count
> > > remains constant. I've verified this on kernels 2.6.21.6; 2.6.20.4;
> > > 2.6.18-4-686-Etch.
> > > The obvious conclusion is that something must have changed it the 2.6.22
> > > kernels, so that removing the "-h" has no effect.
> > > I dunno if my observations are of any value, but I thought You should
> > > know...
> > 
> > I confirm this. First 2.6.21-rcx works OK (if I remember).  In
> > 2.6.22(.1) remove -h option doesn't help - only warning message
> > dissapear, and double spin down also exists in suspend to disk.
> 
> Well, on my box (nx6325) with the appended (experimental) patch applied
> on top of 2.6.23-rc1 with the patchset from

s/2.6.23-rc1/2.6.23-rc2/
