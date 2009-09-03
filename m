Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZICIoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZICIoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZICIoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:44:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46302 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZICIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:44:13 -0400
Date: Thu, 3 Sep 2009 10:43:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
Message-ID: <20090903084353.GB3793@elf.ucw.cz>
References: <1251789947.3483.215.camel@rzhang-dt> <200909022346.11475.rjw@sisk.pl> <20090902215148.GA3429@elf.ucw.cz> <200909030216.04896.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909030216.04896.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-09-03 02:16:04, Rafael J. Wysocki wrote:
> On Wednesday 02 September 2009, Pavel Machek wrote:
> > On Wed 2009-09-02 23:46:11, Rafael J. Wysocki wrote:
> > > On Wednesday 02 September 2009, Pavel Machek wrote:
> > > > On Wed 2009-09-02 23:12:58, Rafael J. Wysocki wrote:
> > > > > On Tuesday 01 September 2009, Pavel Machek wrote:
> > > > > > 
> > > > > > > > > IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
> > > > > > > > > illuminance is beyond the device support range, while the device is
> > > > > > > > > still working normally.
> > > > > > > > > what about exporting these values (0 and -1) to user space directly?
> > > > > > > > 
> > > > > > > > Returning 0 for "below" range and 99999999 for "above" range would be
> > > > > > > > nice, yes. 
> > > > > > > 
> > > > > > > Why not 0 and "all ones" or 0 and -1.
> > > > > > > 
> > > > > > > Is there anything wrong with -1 in particular?
> > > > > > 
> > > > > > Normal people expect -1 to be less than 123, and output is in ascii. If
> > > > > > you make it ((unsigned) ~0) I guess that becomes acceptable.
> > > > > 
> > > > > Well, "-1" is a perfectly valid alphanumerical representation of an int.
> > > > > I don't really see the problem with the "-", unless we're talking about some
> > > > > broken user space, that is.
> > > > 
> > > > No. But if you see illumination value of -1 lumen, do you really
> > > > expect a *lot* of light?
> > > 
> > > Not really.  I'd rather intrepret it as "the number is not to be trusted",
> > > which is what it means.
> > > 
> > > The problem with "all ones" is that it depends on the size of the underlying
> > > data type, which is not nice.  Also, if you want that to be a "big number",
> > > there's no clear rule to tell what the number should actually be.
> > > 
> > > Anyway, this really is a matter of definition.  If we document the attribute
> > > to read as "-1" in specific circumstances, the user space will have to take
> > > that into account.
> > 
> > Well, I'd prefer to specify -1 as "underflow" and 1000000000 as
> > "overflow". Any numbers should work, but ... lets make the interface
> > logical if we can.
> 
> The interface is already defined, isn't it?  And we're now
> considering whether

No, I don't think it is "already defined". Yes the patches float
around, but as nothing is merged we can still fix it easily.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
