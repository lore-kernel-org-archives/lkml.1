Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbXJDSK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbXJDSK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbXJDSKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:10:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbXJDSKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:10:50 -0400
Date: Thu, 4 Oct 2007 14:10:44 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 2/3] x86: fix IO write barriers
Message-ID: <20071004181044.GA23300@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20071004052153.GA15131@wotan.suse.de> <20071004052258.GB15131@wotan.suse.de> <20071004173203.GC5828@redhat.com> <200710041953.16656.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710041953.16656.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 07:53:16PM +0200, Andi Kleen wrote:
 > 
 > > The only vendor that ever implemented OOSTOREs was Centaur, and they
 > > only did in the Winchip generation of the CPUs.  When they dropped it
 > > from the C3, I asked whether they intended to bring it back, and the
 > > answer was "extremely unlikely".
 > >
 > 
 > Do you know if it made a big performance difference?

On the winchip, it was a huge win. I can't remember exact numbers,
but pretty much every benchmark I threw at it at the time showed
significant improvement.

 > But yes we should probably just remove this special case to make 
 > maintenance easier.

It's CONFIG_SMP anyway, which none of the winchips were.
SMP+OOSTORE just didn't happen, and I'd be surprised if
any vendor makes it happen any time soon.
(Even if so, it's likely we'd need to make additional changes
 anyway, so adding it back shouldn't be a big deal.)

	Dave

-- 
http://www.codemonkey.org.uk
