Return-Path: <linux-kernel-owner+w=401wt.eu-S1763879AbYBFXt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763879AbYBFXt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759831AbYBFXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:49:15 -0500
Received: from smtp20.kymp.net ([80.248.96.137]:56449 "EHLO smtp20.kymp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759780AbYBFXtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:49:14 -0500
X-Greylist: delayed 39349 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 18:49:14 EST
Date: Wed, 6 Feb 2008 14:53:22 +0200
From: Mika Bostrom <bostik@bostik.iki.fi>
To: linux-kernel@vger.kernel.org
Subject: Understanding clock drift in virtual machines w/ CFS, NOHZ
Message-ID: <20080206125322.GA2923@bostik.iki.fi>
Reply-To: Mika Bostrom <bostik@bostik.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Good day.

  I have come across the occasional issue of clock drift when running
(earlier) kernels inside a virtual machine. The reason for drift is
simple enough - host may be under heavy load, guest may not get enough
resources to run all the ticks (HZ) it is supposed to. At least to put
it simply.

  Now, I have been wondering how the introduction of CFS and CONFIG_NOHZ
(dynticks) change this, or if they do at all. If I have understood
correctly, only the host's scheduler is really involved so it enters the
picture when host is running a recent kernel. In a pure hypervisor-only
virtualization, that point should be moot.

  And then we have dynticks. Try as I might, I haven't been able to wrap
my head around the combination. What happens to the kernel and
timekeeping when guest has NOHZ enabled?

  My google-fu is not good enough to find the relevant documentation if
such even exists on this subject. To top it off, I'm not certain whether
my question is trivial, non-issue or just plain weird.

  Any pointers on where I should look for more information will be
appreciated.

-- 
 Mika Boström      +358-40-525-7347  -=-  The flogging will continue
 Bostik@iki.fi    www.iki.fi/bostik  -=-  until morale improves
 GPG: 0x039F188E; EC67 5B3A E6E3 6A84 9CB2  94D3 BFCD BD57 039F 188E
