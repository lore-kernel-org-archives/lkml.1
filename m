Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403Ab0AGHeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0AGHeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381Ab0AGHeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:34:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab0AGHeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:34:09 -0500
Date: Thu, 7 Jan 2010 08:34:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 5/5] ACPI, APEI, Document for APEI
Message-ID: <20100107073408.GA1007@atrey.karlin.mff.cuni.cz>
References: <1261980744-4450-2-git-send-email-ying.huang@intel.com> <1261980744-4450-3-git-send-email-ying.huang@intel.com> <1261980744-4450-4-git-send-email-ying.huang@intel.com> <1261980744-4450-5-git-send-email-ying.huang@intel.com> <1261980744-4450-6-git-send-email-ying.huang@intel.com> <20100106071431.GB1494@ucw.cz> <20100106071609.GA1648@ucw.cz> <1262762503.17852.9.camel@yhuang-dev.sh.intel.com> <20100107071254.GE1689@ucw.cz> <1262849184.17852.41.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262849184.17852.41.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 2010-01-07 at 15:12 +0800, Pavel Machek wrote:
> > On Wed 2010-01-06 15:21:43, Huang Ying wrote:
> > > On Wed, 2010-01-06 at 15:16 +0800, Pavel Machek wrote:
> > > > > > +The user interface of EINJ is in debug file system, under the
> > > > > > +directory apei/einj. The following files are provided.
> > > > > > +
> > > > > > +- available_error_type
> > > > > > +  Read this file will return the error injection capability of the
> > > > > > +  platform, that is, which error types are supported. The error type
> > > > > > +  definition is as follow, the left field is the error type value, the
> > > > > > +  right field is error description.
> > > > > > +
> > > > > > +    0x00000001	Processor Correctable
> > > > > > +    0x00000002	Processor Uncorrectable non-fatal
> > > > > > +    0x00000004	Processor Uncorrectable fatal
> > > > > > +    0x00000008  Memory Correctable
> > > > > > +    0x00000010  Memory Uncorrectable non-fatal
> > > > > > +    0x00000020  Memory Uncorrectable fatal
> > > > > > +    0x00000040	PCI Express Correctable
> > > > > > +    0x00000080	PCI Express Uncorrectable fatal
> > > > > > +    0x00000100	PCI Express Uncorrectable non-fatal
> > > > > > +    0x00000200	Platform Correctable
> > > > > > +    0x00000400	Platform Uncorrectable non-fatal
> > > > > > +    0x00000800	Platform Uncorrectable fatal
> > > > > > +
> > > > > > +  The format of file contents are as above, except there are only the
> > > > > > +  available error type lines.
> > > > 
> > > > Strange interface. Why not simply pass single integer -- the bit mask?
> > > > Bit meanings are not going to change, anyway.
> > > 
> > > I have used bit mask in previous versions. But I think this version has
> > > better readability.
> > 
> > Better usability for humans, but kernel interfaces are not for
> > humans. Please revert to bit mask. 
> 
> I think this interface is for humans too. Maybe we can provide both bit
> mask and human readable explanation as now.

It sucks as a kernel interface. If you want nice interface for humans,
create a script.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
