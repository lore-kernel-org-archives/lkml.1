Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZKBQUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZKBQUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZKBQUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:20:45 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:17472 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbZKBQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:20:42 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 11:20:42 EST
Date: Mon, 2 Nov 2009 10:11:27 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091102161127.GA1432522@hiwaay.net>
References: <dAPfP-5R6-1@gated-at.bofh.it> <dBOhH-uY-9@gated-at.bofh.it> <dBPdM-16Z-1@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.1.10.0911011540400.53392@caridad.local>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Ryan C. Gordon <icculus@icculus.org> said:
>I wouldn't imagine this is the target audience for FatELF. For embedded 
>devices, just use the same ELF files you've always used.

What _is_ the target audience?

As I see it, there are three main groups of Linux consumers:

- embedded: No interest in this; adds significant bloat, generally
  embedded systems don't allow random binaries anyway

- enterprise distributions (e.g. Red Hat, SuSE): They have specific
  supported architectures, with partner programs to support those archs.
  If something is supported, they can support all archs with
  arch-specific binaries.

- community distributions (e.g. Ubuntu, Fedora, Debian): This would
  greatly increase build infrastructure complexity, mirror disk space,
  and download bandwidth, and (from a user perspective) slow down update
  downloads significantly.

If you don't have buy-in from at least a large majority of one of these
segments, this is a big waste.  If none of the above support it, it will
not be used by any binary-only software distributors.

Is any major distribution (enterprise or community) going to use this?
If not, kill it now.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
