Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbYEUTmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbYEUTmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYEUTmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:42:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16525 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYEUTmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:42:18 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 15:40:35 -0400
User-Agent: KMail/1.9.9
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080521182949.GL8581@mit.edu> <20080521193633.GA26780@shareable.org>
In-Reply-To: <20080521193633.GA26780@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211540.36276.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008, Jamie Lokier wrote:
> Theodore Tso wrote:
> > On Wed, May 21, 2008 at 11:03:24AM -0700, Andrew Morton wrote:
> > > afaik there is no need to enable this feature if the machine (actually
> > > the disks) are on a UPS, yes?
> >
> > Yes, as long as you're confident that there won't be a kernel
> > bug/regression causing a lockup while the server is under severe
> > memory pressure while doing lots of fsync's, file creations, renames,
> > etc.  And as long as your 100% confident that UPS's will never fail,
> > janitors will never accidentally hit the Emergency Power Office
>
> Can a kernel lockup cause this kind of corruption?

No

>
> Will a system reboot wipe the disk's write cache?
>

Only if you reboot with the power switch (some test rigs do)

> I had imagined only power loss would prevent the disk from
> writing it's cache eventually; is that wrong?
>

-chris
