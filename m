Return-Path: <linux-kernel-owner+w=401wt.eu-S1760982AbYARNcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982AbYARNcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYARNcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:32:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbYARNci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:32:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1: broken suspend (due to git-cpufreq.patch)
Date: Fri, 18 Jan 2008 14:34:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181435.00364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of January 2008, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> - selinux is busted on one of my two selinux-enabled test machines.
> 
> - suspend-to-ram and suspend-to-disk are totally hosed on one of my test
>   machines.  I guess I get to bisect this.

Suspend and hibernation are also broken on my HP nx6325, which is caused by
git-cpufreq.patch.  Reverting this patch and
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch makes things work again.

I reported this already for 2.6.24-rc6-mm1 and Dave said he would look at it
in January.  It's still January, so hopefully he's still going to do that. ;-)

Thanks,
Rafael
