Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZBXGsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZBXGsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZBXGsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:48:33 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:23458 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZBXGsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:48:32 -0500
Date: Mon, 23 Feb 2009 22:48:30 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not ioremap virtual address for G33 hw status page
Message-ID: <20090224064830.GA12600@hexapodia.org>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com> <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl> <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com> <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com> <20090224032304.GA26344@hexapodia.org> <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 09:50:03PM -0800, Yinghai Lu wrote:
> > reg 0, base: 0GB, range: 32GB, type WB
> > reg 1, base: 3584MB, range: 512MB, type UC
> > reg 2, base: 2012MB, range: 4MB, type UC
> > reg 3, base: 2016MB, range: 32MB, type UC
> 
> the BIOS is so sick
> according to MTRR, it said:
> [0,2012M) is WB
> [2048M, 3.5G) is WB too
> [4G, 32G) is WB
> 
> but according to e820: about [0,2g) is RAM...
> 
> really not how to workaround in BIOS.
> 
> please check if you have some new BIOS?

That was with bios A11.  There is an A12 available on dell.com, I'll try
installing it tomorrow...

-andy
