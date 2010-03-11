Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0CKP0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:26:15 -0500
Received: from THUNK.ORG ([69.25.196.29]:58731 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0CKP0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:26:12 -0500
Date: Thu, 11 Mar 2010 10:25:51 -0500
From: tytso@mit.edu
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100311152551.GG1497@thunk.org>
Mail-Followup-To: tytso@mit.edu, Nikanth Karthikesan <knikanth@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Damian Lukowski <damian@tvk.rwth-aachen.de>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
	Daniel Taylor <Daniel.Taylor@wdc.com>,
	Mark Lord <kernel@teksavvy.com>, "H. Peter Anvin" <hpa@zytor.com>,
	hirofumi@mail.parknet.co.jp,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
	aschnell@suse.de, jdelvare@suse.de
References: <4B947393.2050002@kernel.org>
 <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
 <1268318374.2798.2.camel@mulgrave.site>
 <201003112035.26743.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003112035.26743.knikanth@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 08:35:26PM +0530, Nikanth Karthikesan wrote:
> The real problem, here is just that partitioning-tools should create 
> partitions that can work with both XP as well as Windows7. May be distro 
> installers, should ask the user which compatibility he needs.

4k aligned sectors will *work* with Windows XP, will it not?  It's
just simply a matter of Windows XP, being really ancient, doesn't
create properly alligned partitions by default.   

And how often are we going to see Windows XP systems with these new 4k
physical sector drives anyway, where the first OS to touch the
partition is Windows XP?  And in the case where this does happy, the
resulting partition will be result in terribly performance for Windows
XP as well as Linux.

What's the specific scenario which you are trying to solve, and how
likely is it to occur in real life?

					- Ted
