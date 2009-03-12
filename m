Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZCLVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZCLVC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZCLVCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:02:18 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:48745 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZCLVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:02:18 -0400
X-IronPort-AV: E=Sophos;i="4.38,352,1233532800"; 
   d="scan'208";a="141108623"
From: Roland Dreier <rdreier@cisco.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
References: <200903110925.37614.phillips@phunq.net>
	<20090311114211.89eed5b8.akpm@linux-foundation.org>
	<200903112238.55864.phillips@phunq.net>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 12 Mar 2009 14:02:15 -0700
In-Reply-To: <200903112238.55864.phillips@phunq.net> (Daniel Phillips's
	message of "Wed, 11 Mar 2009 22:38:55 -0700")
Message-ID: <aday6vaqwtk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Mar 2009 21:02:15.0735 (UTC) FILETIME=[D295CC70:01C9A355]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > By the way, the endian comment in bitmap.c needs some loving:
 > 
 >    http://lxr.linux.no/linux+v2.6.28.7/lib/bitmap.c#L35
 > 
 > The s390 file needs to be config-independent:
 > 
 > -	include/asm-s390/bitops.h
 > +	arch/s390/include/asm/bitops.h
 > 
 > and the ppc file is nowhere to be seen.  I will put a driveby patch on
 > the to.do list.

The ppc file is arch/powerpc/include/asm/bitops.h.

 - R.
