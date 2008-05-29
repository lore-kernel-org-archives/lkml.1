Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYE2Nga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYE2Nga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYE2NgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:36:19 -0400
Received: from sandeen.net ([209.173.210.139]:30019 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYE2NgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:36:18 -0400
Message-ID: <483EB151.0@sandeen.net>
Date: Thu, 29 May 2008 08:36:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jamie@shareable.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org>
In-Reply-To: <20080516130545.845a3be9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 16 May 2008 14:02:46 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> A collection of patches to make ext3 & 4 use barriers by
>> default, and to call blkdev_issue_flush on fsync if they
>> are enabled.
> 
> Last time this came up lots of workloads slowed down by 30% so I
> dropped the patches in horror.
> 
> I just don't think we can quietly go and slow everyone's machines down
> by this much.  The overhead of journalling is already pretty horrid.
> 
> If we were seeing a significant number of "hey, my disk got wrecked"
> reports which attributable to this then yes, perhaps we should change
> the default.  But I've never seen _any_, although I've seen claims that
> others have seen reports.

Here's a recent one, just FYI.

http://marc.info/?l=ext3-users&m=121205834608161&w=2

-Eric

