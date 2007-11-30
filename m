Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbXK3XIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbXK3XIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbXK3XIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:08:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbXK3XIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:08:40 -0500
Message-ID: <475097EB.30604@redhat.com>
Date: Fri, 30 Nov 2007 17:08:27 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: cmm@us.ibm.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
References: <1183275490.4010.134.camel@localhost.localdomain>
In-Reply-To: <1183275490.4010.134.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mingming Cao wrote:
> [PATCH] jbd2 stats through procfs
> 
> The patch below updates the jbd stats patch to 2.6.20/jbd2.
> The initial patch was posted by Alex Tomas in December 2005
> (http://marc.info/?l=linux-ext4&m=113538565128617&w=2).
> It provides statistics via procfs such as transaction lifetime and size.
> 
> [ This probably should be rewritten to use debugfs?   -- Ted]
> 
> Signed-off-by: Johann Lombardi <johann.lombardi@bull.net>

I've started going through this one to clean it up to the point where it
can go forward.  It's been sitting at the top of the unstable portion of
the patch queue for long enough, I think :)

I've converted the msecs to jiffies until the user boundary, changed the
union #defines as suggested by Andrew, and various other little issues etc.

Remaining to do is a generic time-difference calculator (instead of
jbd2_time_diff), and looking into whether it should be made a config
option; I tend to think it should, but it's fairly well sprinkled
through the code, so I'll see how well that works.

Also did we ever decided if this should go to debugfs?

Thanks,

-Eric
