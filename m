Return-Path: <linux-kernel-owner+w=401wt.eu-S936601AbYEUTia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936601AbYEUTia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbYEUTiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:38:19 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50178 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063AbYEUTiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:38:18 -0400
Date: Wed, 21 May 2008 20:36:33 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       Eric Sandeen <sandeen@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080521193633.GA26780@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com> <20080521112224.GD5028@ucw.cz> <20080521110324.668048e0.akpm@linux-foundation.org> <20080521182949.GL8581@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521182949.GL8581@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, May 21, 2008 at 11:03:24AM -0700, Andrew Morton wrote:
> > 
> > afaik there is no need to enable this feature if the machine (actually
> > the disks) are on a UPS, yes?
> 
> Yes, as long as you're confident that there won't be a kernel
> bug/regression causing a lockup while the server is under severe
> memory pressure while doing lots of fsync's, file creations, renames,
> etc.  And as long as your 100% confident that UPS's will never fail,
> janitors will never accidentally hit the Emergency Power Office

Can a kernel lockup cause this kind of corruption?

Will a system reboot wipe the disk's write cache?

I had imagined only power loss would prevent the disk from
writing it's cache eventually; is that wrong?

-- Jamie

