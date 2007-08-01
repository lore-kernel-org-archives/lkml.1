Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbXHAQyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbXHAQyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXHAQx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:53:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50742 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbXHAQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:53:55 -0400
Date: Wed, 1 Aug 2007 10:53:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Message-ID: <20070801165352.GB21219@parisc-linux.org>
References: <20070705194909.337398431@intel.com> <20070705130518.135e4e3c.kristen.c.accardi@intel.com> <46AE12B6.6090408@garzik.org> <46AED656.8070407@gmail.com> <1185891488.3468.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185891488.3468.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 09:18:08AM -0500, James Bottomley wrote:
> The other comment is that power saving seems to be a property of the
> transport rather than the host.  If you do it in the transport classes,
> then you can expose all the knobs the actual transport possesses (which
> is, unfortunately, none for quite a few SCSI transports).

Would it save any power to negotiate down to, say, FAST-20 for the SPI
transport?  Or to negotiate narrow instead of wide, so fewer cables have
to be powered?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
