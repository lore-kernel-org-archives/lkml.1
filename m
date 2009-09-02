Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZIBVME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZIBVME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZIBVMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:12:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35084 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZIBVMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:12:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
Date: Wed, 2 Sep 2009 23:12:58 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1251789947.3483.215.camel@rzhang-dt> <200909012047.00606.rjw@sisk.pl> <20090901134144.GA2028@ucw.cz>
In-Reply-To: <20090901134144.GA2028@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909022312.58494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 September 2009, Pavel Machek wrote:
> 
> > > > IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
> > > > illuminance is beyond the device support range, while the device is
> > > > still working normally.
> > > > what about exporting these values (0 and -1) to user space directly?
> > > 
> > > Returning 0 for "below" range and 99999999 for "above" range would be
> > > nice, yes. 
> > 
> > Why not 0 and "all ones" or 0 and -1.
> > 
> > Is there anything wrong with -1 in particular?
> 
> Normal people expect -1 to be less than 123, and output is in ascii. If
> you make it ((unsigned) ~0) I guess that becomes acceptable.

Well, "-1" is a perfectly valid alphanumerical representation of an int.
I don't really see the problem with the "-", unless we're talking about some
broken user space, that is.

Rafael
