Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbYARUrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbYARUrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760316AbYARUrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:47:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760131AbYARUrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:47:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.24-rc8-mm1: broken suspend (due to git-cpufreq.patch)
Date: Fri, 18 Jan 2008 21:50:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <200801181435.00364.rjw@sisk.pl> <20080118171036.GB29889@redhat.com>
In-Reply-To: <20080118171036.GB29889@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801182150.35483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 18 of January 2008, Dave Jones wrote:
> On Fri, Jan 18, 2008 at 02:34:59PM +0100, Rafael J. Wysocki wrote:
>  > On Thursday, 17 of January 2008, Andrew Morton wrote:
>  > > 
>  > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
>  > > 
>  > > - selinux is busted on one of my two selinux-enabled test machines.
>  > > 
>  > > - suspend-to-ram and suspend-to-disk are totally hosed on one of my test
>  > >   machines.  I guess I get to bisect this.
>  > 
>  > Suspend and hibernation are also broken on my HP nx6325, which is caused by
>  > git-cpufreq.patch.  Reverting this patch and
>  > drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch makes things work again.
>  > 
>  > I reported this already for 2.6.24-rc6-mm1 and Dave said he would look at it
>  > in January.  It's still January, so hopefully he's still going to do that. ;-)
> 
> Given that laptop has a K8 CPU, it's highly likely that it's this patch..
> http://userweb.kernel.org/~davej/pn.diff
> Can you revert just that on top of -mm, (or just try this standalone on top of -rc8)
> and confirm this is problematic ?

Reverting it from the -mm makes things work.  I'll check if it breaks things
when applied on top of -rc8.
