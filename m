Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZABAGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZABAGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 19:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZABAGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 19:06:00 -0500
Received: from mail.fieldses.org ([141.211.133.115]:45608 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZABAF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 19:05:59 -0500
X-Greylist: delayed 2344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2009 19:05:59 EST
Date: Thu, 1 Jan 2009 18:26:37 -0500
To: Benny Halevy <bhalevy@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       open-osd development <osd-dev@open-osd.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, avishay@gmail.com,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Message-ID: <20090101232637.GC31367@fieldses.org>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <495C8B65.4010202@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495C8B65.4010202@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 11:22:45AM +0200, Benny Halevy wrote:
> On Dec. 31, 2008, 17:57 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > I don't like it mainly because it's not truly a useful general framework
> > for others to build on.  However, as argued above, there might not
> > actually be such a useful framework, so as long as the only two
> > consumers (you and Lustre) want an interface like this, I'll put it in.
> 
> Not to mention pnfs over objects which is coming up around the corner.
> The pnfs-obj layout driver will use the osd initiator library as well
> for distributed data I/O access (while the metadata server, to be based
> on exofs accesses the OSD for metadata and security ops too)

What state is that project in right now?

--b.
