Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZHQRGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZHQRGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZHQRGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:06:50 -0400
Received: from mail.atheros.com ([12.36.123.2]:58138 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZHQRGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:06:49 -0400
Date: Mon, 17 Aug 2009 10:06:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
       "aquilaver@yahoo.com" <aquilaver@yahoo.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dan Williams <dcbw@redhat.com>, Kai Engert <kengert@redhat.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, Tim de Waal <tim.dewaal@yahoo.com>,
       Roy Marples <uberlord@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christian Lamparter <chunkeey@web.de>,
       =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH v4 34/34] wireless: mark prism54.ko as deprecated and
 mark for removal
Message-ID: <20090817170644.GE4352@mosca>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
 <1250281559-13041-35-git-send-email-lrodriguez@atheros.com>
 <1250323182.15069.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1250323182.15069.0.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 12:59:42AM -0700, Johannes Berg wrote:
> On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:
> > The preferred modules is p54.ko, which also supports FullMAC
> > PCI / Cardbus devices. We schedule removal for 2.6.34. Reason
> > to remove this is no one really is testing prism54.ko anymore,
> > and while it works p54.ko provides support for the same hardware.
> > It should be noted I have been told some FullMAC devices may not
> > have worked with the SoftMAC driver but to date we have yet to
> > recieve a single bug report regarding this. If there are users
> > out there please let us know!
> 
> Not that I care about the changelog, but I do find it illogical to refer
> to modules w/o .ko everywhere and then with .ko in the changelog. Of
> course you were consistent ;)

Heh I've gone and cleaned this up in the series, I just removed the
.ko usage when I refer to modules in the entries and commit log.

> > -	  The module will be called prism54.
> > +	  When built as module you get prism54.ko
> 
> NAK this change.

Heh ok, changed it.

  Luis
