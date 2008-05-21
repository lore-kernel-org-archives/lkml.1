Return-Path: <linux-kernel-owner+w=401wt.eu-S936411AbYEUSuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936411AbYEUSuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbYEUSuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:50:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933095AbYEUSuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:50:16 -0400
Date: Wed, 21 May 2008 11:49:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       Eric Sandeen <sandeen@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-Id: <20080521114917.60bf42c7.akpm@linux-foundation.org>
In-Reply-To: <20080521182949.GL8581@mit.edu>
References: <482DDA56.6000301@redhat.com>
	<20080518211140.b29bee30.akpm@linux-foundation.org>
	<200805191316.27551.chris.mason@oracle.com>
	<200805191439.36577.chris.mason@oracle.com>
	<20080521112224.GD5028@ucw.cz>
	<20080521110324.668048e0.akpm@linux-foundation.org>
	<20080521182949.GL8581@mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 14:29:49 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Wed, May 21, 2008 at 11:03:24AM -0700, Andrew Morton wrote:
> > 
> > afaik there is no need to enable this feature if the machine (actually
> > the disks) are on a UPS, yes?
> 
> Yes, as long as you're confident that there won't be a kernel
> bug/regression causing a lockup while the server is under severe
> memory pressure while doing lots of fsync's, file creations, renames,
> etc.

That won't cause corruption, will it?  The problem is purely one of
"data which the disk acked didn't make it to platter"?

>  And as long as your 100% confident that UPS's will never fail,
> janitors will never accidentally hit the Emergency Power Office
> switch, and so on.

Well.  The product of two very small numbers is...
