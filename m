Return-Path: <linux-kernel-owner+w=401wt.eu-S1762274AbYARRLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274AbYARRLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbYARRK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:10:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbYARRK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:10:58 -0500
Date: Fri, 18 Jan 2008 12:10:36 -0500
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-mm1: broken suspend (due to git-cpufreq.patch)
Message-ID: <20080118171036.GB29889@redhat.com>
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

Given that laptop has a K8 CPU, it's highly likely that it's this patch..
http://userweb.kernel.org/~davej/pn.diff
Can you revert just that on top of -mm, (or just try this standalone on top of -rc8)
and confirm this is problematic ?

The rest of the stuff in cpufreq.git looks benign at first look.

	Dave

-- 
http://www.codemonkey.org.uk
