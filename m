Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbZANVxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbZANVxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbZANVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:53:19 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59617 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbZANVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:53:18 -0500
Message-ID: <496E5ECA.6030306@us.ibm.com>
Date: Wed, 14 Jan 2009 15:53:14 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/9] oprofile: implement support of samples with variable
 data size
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> This patch series implements support of samples with variable data
> size. Current implementation has a fixed sample size of 2 unsigned
> longs. This makes it hard to implement use cases with a different
> sample size (AMD IBS or power pc cell) since buffer locking is
> required or samples my become incomplete. The internal cpu buffer
> usage has been changed now and allows the attachment of data with
> varable length to samples.
> 
> There are patches that also change the current ibs implementation. In
> the end the ibs implentation could be removed from the general
> oprofile code to model specific code. An API is available that
> provides generic functions to use variable sample sizes.
> 
> The patches are also available here:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git oprofile-for-tip
This patch set looks fine.  Nice work!  I still need to test on a couple of platforms, though.  Feel free to bug me if I don't get back to you with results within a week or so.

-Maynard
> 
> -Robert
> 
> 
> 
> 
> ------------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It is the best place to buy or sell services for
> just about anything Open Source.
> http://p.sf.net/sfu/Xq1LFB
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list

