Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXLWW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXLWW44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 17:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXLWW4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 17:56:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbXLWW4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 17:56:48 -0500
Date: Sun, 23 Dec 2007 17:56:16 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.24-rc6-mm1: suspend broken on HP nx6325 due to cpufreq
	changes
Message-ID: <20071223225616.GC20364@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712232354.40814.rjw@sisk.pl> <20071223145003.5c36a40a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223145003.5c36a40a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 02:50:03PM -0800, Andrew Morton wrote:

 > > > - Someone broke suspend-to-RAM on the t61p again.  It just instantly resumes
 > > >   itself.
 > > 
 > > Suspend is also broken on my HP nx6325 (hangs hard in the last phase of
 > > suspend) and git-cpufreq.patch is responsible for that (as shown by bisection).
 > > 
 > > Reverting git-cpufreq.patch makes suspend work again,
 > 
 > ah.  Thanks.

I'm not sure how this is 'new' breakage, because git-cpufreq hasn't changed
in a while, other than the integration of that missing #include diff
that sat in -mm.   Maybe some bad interaction with something else that
changed perhaps. *shrug*.

I'm on vacation until the new year, so I'm going out of my way not to look
at bugs for a change.  But I'm not ignoring this completely, I'll make a
note to look at it in January.
 
	Dave

-- 
http://www.codemonkey.org.uk
