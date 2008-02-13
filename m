Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbYBMSRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbYBMSRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYBMSRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:17:22 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40270 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbYBMSRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:17:20 -0500
Subject: Re: [PATCH] enclosure: add support for enclosure services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: kristen.c.accardi@intel.com
Cc: ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
In-Reply-To: <20080213094502.4112d5e5@appleyard>
References: <1202172065.3096.154.camel@localhost.localdomain>
	 <922945.25870.qm@web31811.mail.mud.yahoo.com>
	 <20080212102244.32869382@appleyard>
	 <1202841935.3137.94.camel@localhost.localdomain>
	 <20080212110752.21840627@appleyard>
	 <1202844495.3137.120.camel@localhost.localdomain>
	 <20080213094502.4112d5e5@appleyard>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 12:17:09 -0600
Message-Id: <1202926629.3109.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 09:45 -0800, Kristen Carlson Accardi wrote:
> I don't think I'm arguing whether or not your solution may work, what I
> am arguing is really a more philosophical point.  Not "can we do it
> this way", but "should we do it way".  I am of the opinion that
> management belongs in userspace.  I also am of the opinion that if you
> can successfully accomplish something in user space, you should.  I
> also believe that even if you provide this basic interface, all system
> vendors are going to provide libraries on top of that to customize it,
> so you've not added much value to just a simple message passing
> interface.

I'm not necessarily arguing against that.  However, what you're
providing is slightly more than just a userspace tap into the enclosure.
You're adding a file to display and control the enclosure state
(sw_activity).  This constitutes an ad-hoc sysfs interface.  I'm not
telling you not to do it, but I am pleading that if we have to have all
these sysfs interfaces, lets at least do it in a uniform way.

Enclosures are such nasty beasts, that even the job of getting a tap
into them is problematic, so if we have a different tap infrastructure
for every different enclosure type and connection it's still going to be
pretty unmanageable to a userspace interface.

> So, I'm happy to defer to Jeff's judgement call here - I just want to
> do what's right for our customers and get an enclosure management
> interface for SATA exposed, preferrably in time for the 2.6.26 merge
> window.  If he prefers your design, I'll disagree, but commit to his
> decision and try to get this to work for SATA. If he'd rather see
> something along the lines of what I proposed, then since it is 100% self
> contained in the SATA subsystem, it shouldn't impact whatever you
> want to do in the SCSI subsystem.

James


