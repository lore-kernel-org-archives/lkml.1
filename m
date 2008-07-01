Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYGAVQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYGAVQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYGAVPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:15:53 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:33372 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbYGAVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:15:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYGANexXkh5LFnmWmdsb2JhbACSYAEdm0A
X-IronPort-AV: E=Sophos;i="4.27,733,1204464600"; 
   d="scan'208";a="147611470"
Date: Wed, 2 Jul 2008 07:15:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: xfs-masters@oss.sgi.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Message-ID: <20080701211550.GU29319@disturbed>
Mail-Followup-To: xfs-masters@oss.sgi.com,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <4744FD87.7010301@goop.org> <200807010038.43362.rjw@sisk.pl> <20080701063835.GQ29319@disturbed> <200807011635.44696.rjw@sisk.pl> <87tzf9hcg6.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzf9hcg6.fsf@denkblock.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 05:05:29PM +0200, Elias Oltmanns wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > Do all of the filesystems implement the freezing?
> 
> There is some work in progress [1].
[....]
> [1] http://permalink.gmane.org/gmane.linux.file-systems/24716

No, that's the userspace ioctl interface to enable freezing from
something other than dm-snapshot. The filesystems that is aimed at
already support freezing via freeze_bdev().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
