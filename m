Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXIUWPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXIUWPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXIUWPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:15:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035AbXIUWPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:15:09 -0400
Date: Fri, 21 Sep 2007 18:14:27 -0400
From: Dave Jones <davej@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix printk levels in intel-rng
Message-ID: <20070921221427.GI11455@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Roland Dreier <rdreier@cisco.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070921215351.GH11455@redhat.com> <ada7imjy8sn.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7imjy8sn.fsf@cisco.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 03:04:40PM -0700, Roland Dreier wrote:
 >  > [   41.250634] intel_rng: Firmware space is locked read-only. <4>intel_rng: If you can't or
 >  > [   41.250638]  don't want to <4>intel_rng: disable this in firmware setup, and <4>intel_rng: if
 >  > [   41.250639]  you are certain that your <4>intel_rng: system has a functional
 >  > [   41.250641]  RNG, try<4>intel_rng: using the 'no_fwh_detect' option.
 >  > [   41.250706] agpgart: AGP aperture is 128M @ 0xe8000000
 > 
 >  >  			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
 >  > -			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
 >  > -			KERN_WARNING PFX "you are certain that your system has a functional\n"
 >  > -			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
 >  > +			PFX "don't want to disable this in firmware setup, and if\n"
 >  > +			PFX "you are certain that your system has a functional\n"
 >  > +			PFX "RNG, try using the 'no_fwh_detect' option.\n";
 > 
 > I think Alan already fixed this in f3dc8c18 -- notice that your
 > screwed-up message has the <4> after eg read-only, and the current
 > code doesn't line-wrap there.

Ah, was looking at a dmesg from an older kernel. Good catch.

Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
