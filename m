Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbZIQNhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbZIQNhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZIQNhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:37:23 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:53027 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbZIQNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:37:22 -0400
Date: Thu, 17 Sep 2009 14:37:20 +0100
From: Chris Webb <chris@arachsys.com>
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Message-ID: <20090917133720.GM5418@arachsys.com>
References: <20090907114442.GG18831@arachsys.com>
 <20090907115927.GU8710@arachsys.com>
 <20090909120218.GB21829@arachsys.com>
 <4AADF3C4.5060004@kernel.org>
 <4AADF471.2020801@suse.de>
 <4AAE3B9A.2060306@rtr.ca>
 <4AAE3F86.8090804@suse.de>
 <4AAE524C.2030401@rtr.ca>
 <20090916231921.GL1924@arachsys.com>
 <4AB239C8.2020203@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB239C8.2020203@rtr.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <liml@rtr.ca> writes:

> Yes.  Is this still happening from time to time now?

Hi Mark. We're still seeing the flush timeouts (0xea) with accompanying
errors, but not the IDENTIFYs anymore. We now don't have smartd nor smartctl
on the systems, and there's nothing else running in userspace that accesses
the drives other than via block reads and writes via the md arrays.

Cheers,

Chris.
