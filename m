Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZFXSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZFXSu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZFXSuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:50:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46314 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbZFXSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:50:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V3
Date: Wed, 24 Jun 2009 20:50:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, gregkh@suse.de,
       khilman@deeprootsystems.com, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se> <87r5xhqzr4.fsf@deeprootsystems.com> <aec7e5c30906240450w2c204b1bo8e06cdc26eaad753@mail.gmail.com>
In-Reply-To: <aec7e5c30906240450w2c204b1bo8e06cdc26eaad753@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906242050.57312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Magnus Damm wrote:
> On Fri, Jun 19, 2009 at 1:21 AM, Kevin
> Hilman<khilman@deeprootsystems.com> wrote:
> > Magnus Damm <magnus.damm@gmail.com> writes:
> >
> >> From: Magnus Damm <damm@igel.co.jp>
> >>
> >> Allow architecture specific data in struct platform_device V3.
> >>
> >> With this patch struct pdev_archdata is added to struct
> >> platform_device, similar to struct dev_archdata in found in
> >> struct device. Useful for architecture code that needs to
> >> keep extra data associated with each platform device.
> >>
> >> Struct pdev_archdata is different from dev.platform_data, the
> >> convention is that dev.platform_data points to driver-specific
> >> data. It may or may not be required by the driver. The format
> >> of this depends on driver but is the same across architectures.
> >>
> >> The structure pdev_archdata is a place for architecture specific
> >> data. This data is handled by architecture specific code (for
> >> example runtime PM), and since it is architecture specific it
> >> should _never_ be touched by device driver code. Exactly like
> >> struct dev_archdata but for platform devices.
> >>
> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> >
> > Since there is no 'Feature-desired-by:' tag, I'll addd
> >
> > Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
> >
> > For PM on ARM in general, and OMAP in particular we definitely need a
> > generic way to handle arch-specific data per platform_device.
> 
> Thanks, Kevin! So ARM in general or at least OMAP wants this, and so
> does SuperH.
> 
> Rafael, you kindly gave feedback on earlier versions, are you ok with
> this version?

Yes, I am.  I'm planning to include it into my linux-next branch for 2.6.32, if
no one objects.

Best,
Rafael
