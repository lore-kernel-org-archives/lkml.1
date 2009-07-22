Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbZGVPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbZGVPPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZGVPPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:15:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZGVPPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:15:21 -0400
Date: Wed, 22 Jul 2009 17:15:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: GFS2: Add LED support to GFS2
Message-ID: <20090722151521.GB6035@basil.fritz.box>
References: <1248260198.3456.4.camel@localhost.localdomain> <87k5203hdx.fsf@basil.nowhere.org> <1248274288.3298.5.camel@localhost.localdomain> <20090722145534.GA6035@basil.fritz.box> <1248274951.3298.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248274951.3298.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I did consider adding a feature to filter events on a per superblock
> basis, but I decided against it in the end, as it seemed to be making
> things too complicated (how should we specify the superblock? what
> should the user interface be?).

Maybe key on mount points? (so passing vfsmnts) 

So have some sysfs file where you echo mount points into to enable
LED activity.

Ok that would be a little clumpsy for a "10 million bind mounts" case,
but presumably that's very rare and they can still make it work.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
