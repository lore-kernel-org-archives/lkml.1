Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYCZX6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYCZX6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYCZX6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:58:08 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:50460 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYCZX6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:58:07 -0400
Date: Thu, 27 Mar 2008 00:57:57 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Markus Rehbach <markus.rehbach@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <20080325233357.17d6ac41.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0803270046130.5041@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Andrew Morton wrote:
> Markus reported what looks to be the same thing here:
> http://lkml.org/lkml/2008/3/21/202 and it's already in the regresison list.

Yes, I've found 3 more reports for __d_lookup on kerneloops.org, first 
seen for 2.6.25-rc5-git5.

> I can't think what we did to cause this.  Were you doing anything unusual
> on that machine?

Well, I was reading mail...and suddenly alpine complained that the imap 
server was gone - and indeed "imap" was in the Oops message. But apart 
from that, nothing exotic going on.

>  I see the fuse module was loaded - was it being used?

No, it's loaded, but it was not in use.

> Were any oddball (ie: non-ext3 ;)) filesystems being used?  etc.

There's ext2/3/4, jfs, xfs, reiserfs (not reiser4) - the whole family.
The only oddball coming to mind is zd1211rw with its binary firmware. But 
no SMP, no ACPI, no preempt...

Christian.
-- 
BOFH excuse #90:

Budget cuts
