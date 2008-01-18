Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbYARQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbYARQyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYARQyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:54:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759073AbYARQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:54:08 -0500
Date: Fri, 18 Jan 2008 11:53:50 -0500
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-mm1: broken suspend (due to git-cpufreq.patch)
Message-ID: <20080118165350.GA29889@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <200801181435.00364.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181435.00364.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 02:34:59PM +0100, Rafael J. Wysocki wrote:
 > On Thursday, 17 of January 2008, Andrew Morton wrote:
 > > 
 > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
 > > 
 > > - selinux is busted on one of my two selinux-enabled test machines.
 > > 
 > > - suspend-to-ram and suspend-to-disk are totally hosed on one of my test
 > >   machines.  I guess I get to bisect this.
 > 
 > Suspend and hibernation are also broken on my HP nx6325, which is caused by
 > git-cpufreq.patch.  Reverting this patch and
 > drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch makes things work again.
 > 
 > I reported this already for 2.6.24-rc6-mm1 and Dave said he would look at it
 > in January.  It's still January, so hopefully he's still going to do that. ;-)

Yeah, I put myself out of action for a few weeks.  I'm back now.
I'll look at this today.  Thanks for the reminder.

	Dave

-- 
http://www.codemonkey.org.uk
