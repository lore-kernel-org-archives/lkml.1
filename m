Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbYBKR7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbYBKR7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758846AbYBKR67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:58:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758756AbYBKR65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:58:57 -0500
Date: Mon, 11 Feb 2008 12:56:15 -0500
From: Dave Jones <davej@redhat.com>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: [PATCH 1/4] cpufreq: change cpu freq tables to per_cpu
	variables
Message-ID: <20080211175615.GA5408@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mike Travis <travis@sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
	Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
References: <20080208233738.108449000@polaris-admin.engr.sgi.com> <20080208233738.292421000@polaris-admin.engr.sgi.com> <20080211024835.GD26696@codemonkey.org.uk> <47B086A3.9040508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B086A3.9040508@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 09:32:19AM -0800, Mike Travis wrote:
 > Dave Jones wrote:
 > > On Fri, Feb 08, 2008 at 03:37:39PM -0800, Mike Travis wrote:
 > >  > Change cpu frequency tables from arrays to per_cpu variables.
 > >  > 
 > >  > Based on linux-2.6.git + x86.git
 > > 
 > > Looks ok to me.   Would you like me to push this though cpufreq.git,
 > > or do you want the series to go through all in one?
 > 
 > Thanks Dave.  The patches are pretty much independent but it is
 > easier to keep track of them if they go in together.

No problem.  Feel free to add my
Signed-off-by: Dave Jones <davej@redhat.com>

 >  Btw, I have
 > another set coming shortly that I'm testing now.  It should remove
 > most of the remaining references to NR_CPUS.

Cool! As a distro kernel maintainer, this is appreciated.
Keeping everyone happy isn't easy, and work like this definitly
goes a long way towards that goal.

	Dave

-- 
http://www.codemonkey.org.uk
