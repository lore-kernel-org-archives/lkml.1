Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZGVPds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZGVPds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZGVPdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:33:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34723 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZGVPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:33:47 -0400
Date: Wed, 22 Jul 2009 17:33:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: GFS2: Add LED support to GFS2
Message-ID: <20090722153345.GC6035@basil.fritz.box>
References: <1248260198.3456.4.camel@localhost.localdomain> <87k5203hdx.fsf@basil.nowhere.org> <1248274288.3298.5.camel@localhost.localdomain> <20090722145534.GA6035@basil.fritz.box> <1248274951.3298.11.camel@localhost.localdomain> <20090722151521.GB6035@basil.fritz.box> <1248276281.3298.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248276281.3298.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 04:24:41PM +0100, Steven Whitehouse wrote:
> That might be an issue though... there might be multiple super blocks
> for a single mount point I think. We could try specifying devices
> instead, but there might be multiple devices for one fs.

Yes also e.g. for log activity or error it will be probably hard to 
always get back to the vfsmnt. Perhaps wasn't that hot an idea.
Probably would need to key on sbs internally. As a user interface
it still has some promise I think though.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
