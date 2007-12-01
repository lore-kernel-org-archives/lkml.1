Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbXLABWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbXLABWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbXLABWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:22:20 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45817 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbXLABWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:22:19 -0500
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <475097EB.30604@redhat.com>
References: <1183275490.4010.134.camel@localhost.localdomain>
	 <475097EB.30604@redhat.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 30 Nov 2007 17:22:16 -0800
Message-Id: <1196472136.11479.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 17:08 -0600, Eric Sandeen wrote:
> Mingming Cao wrote:
> > [PATCH] jbd2 stats through procfs
> > 
> > The patch below updates the jbd stats patch to 2.6.20/jbd2.
> > The initial patch was posted by Alex Tomas in December 2005
> > (http://marc.info/?l=linux-ext4&m=113538565128617&w=2).
> > It provides statistics via procfs such as transaction lifetime and size.
> > 
> > [ This probably should be rewritten to use debugfs?   -- Ted]
> > 
> > Signed-off-by: Johann Lombardi <johann.lombardi@bull.net>
> 
> I've started going through this one to clean it up to the point where it
> can go forward.  It's been sitting at the top of the unstable portion of
> the patch queue for long enough, I think :)
> 
Thanks!

> I've converted the msecs to jiffies until the user boundary, changed the
> union #defines as suggested by Andrew, and various other little issues etc.
> 
> Remaining to do is a generic time-difference calculator (instead of
> jbd2_time_diff), and looking into whether it should be made a config
> option; I tend to think it should, but it's fairly well sprinkled
> through the code, so I'll see how well that works.
> 
> Also did we ever decided if this should go to debugfs?
> 

I thought it was decided to keep it on procfs as debugfs is not always
on...
> Thanks,
> 
> -Eric
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

