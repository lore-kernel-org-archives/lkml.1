Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbYFXGrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbYFXGrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYFXGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:47:12 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41251 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYFXGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:47:11 -0400
Date: Tue, 24 Jun 2008 00:47:07 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
In-reply-to: <20080623133855.c00ddaa7.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: FD Cami <francois.cami@free.fr>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>
Message-id: <20080624064707.GF6239@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080622201841.669ff882@olorin>
 <20080623203107.GD6239@webber.adilger.int>
 <20080623133855.c00ddaa7.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 23, 2008  13:38 -0700, Randy Dunlap wrote:
> On Mon, 23 Jun 2008 14:31:07 -0600 Andreas Dilger wrote:
> > >  	ext3_warning(sb, __func__,
> > > -		     "updating to rev %d because of new feature flag, "
> > > -		     "running e2fsck is recommended",
> > > -		     EXT3_DYNAMIC_REV);
> > > +			"updating to rev %d because of new feature flag, "
> > > +			"running e2fsck is recommended",
> > > +			EXT3_DYNAMIC_REV);
> > 
> > Please don't change all of the indenting.  The old indending is proper
> > linux coding style (aligned with previous '('), the new one is not.
> 
> Hi,
> I don't mind which way it's done, but I'm curious:  are you saying that
> aligning with '(' is codified (e.g., in CodingStyle) or just that it's
> dominant?

You're right - it isn't in the Linux CodingStyle...  It is the style
that we use for Lustre that explicitly requires aligning with '('.
The common stype definitely IS to align with the previous '(' if a line
is a continuation.

That said, it is IMHO bad form to go and change all of the indenting of
existing code with little reason to do so.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

