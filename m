Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYH3Oig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYH3Oig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYH3Oi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:38:28 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:58774 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751610AbYH3Oi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:38:27 -0400
Date: Sat, 30 Aug 2008 10:38:08 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shrink printk timestamp field
Message-ID: <20080830143808.GA10821@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827151759.GA10678@tsunami.ccur.com> <20080829163540.634e86d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829163540.634e86d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 07:35:40PM -0400, Andrew Morton wrote:
> On Wed, 27 Aug 2008 11:17:59 -0400 Joe Korty <joe.korty@ccur.com> wrote:
> 
> > Shrink the printk timestamp field.
> >
> > Keep the printk timestamp from occupying more of the
> > scarce, 80-column console line space than it really needs.
> >
> 
> This is a significant loss in utility.
> 
> [   16.817285] md: Autodetecting RAID arrays.
> [   16.817288] md: Scanned 0 and added 0 devices.
> [   16.817290] md: autorun ...
> [   16.817292] md: ... autorun DONE.
> 
> This not-terribly-fast machine can emit printks into the log buffer
> within two microseconds.  That's a pretty useful ad-hoc timing
> factility.
> 
> This patch will reduce the precision by a factor of five hundred.

I was looking at it from the point of view of finding out where the
boot process was too slow.  For that millisecs is enough.  I am not
sure where knowing printk output to the microsec would be useful for
solving anything.

Joe
