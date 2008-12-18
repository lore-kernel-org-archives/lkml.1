Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYLSHVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYLSHVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 02:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYLSHVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 02:21:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55130 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYLSHVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 02:21:46 -0500
Date: Thu, 18 Dec 2008 14:00:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [patch 01/22] AMD IOMMU: enable device isolation per default
Message-ID: <20081218130015.GA1420@ucw.cz>
References: <20081216235704.347182084@mini.kroah.org> <20081217000353.GB4504@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217000353.GB4504@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-16 16:03:53, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Joerg Roedel <joerg.roedel@amd.com>
> 
> commit 3ce1f93c6d53c3f91c3846cf66b018276c8ac2e7 upstream.
> 
> Impact: makes device isolation the default for AMD IOMMU
> 
> Some device drivers showed double-free bugs of DMA memory while testing
> them with AMD IOMMU. If all devices share the same protection domain
> this can lead to data corruption and data loss. Prevent this by putting
> each device into its own protection domain per default.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

This does not look like 'fix for a serious bug' to
me. stable_kernel_rules.txt says '...not a "this could be a problem"
type thing'.

Yes, maybe iommu is mature enough that we want it enabled, but...

(Or maybe Documentation/stable_kernel_rules.txt needs updating. The
patch for penguin dirty feet already got in.....)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
