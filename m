Return-Path: <linux-kernel-owner+w=401wt.eu-S1764481AbXEYRia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764481AbXEYRia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763529AbXEYRiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:38:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXEYRiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:38:19 -0400
Date: Fri, 25 May 2007 13:38:13 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Multiple free during oprofile unload
Message-ID: <20070525173813.GA2875@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <4656FA04.5000403@redhat.com> <200705251742.35692.ak@novell.com> <20070525161837.GA26105@redhat.com> <200705251913.53097.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705251913.53097.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 07:13:52PM +0200, Andi Kleen wrote:
 > 
 > > 
 > > So what, the alternative is leave oprofile busted in 2.6.21.x even longer?
 > 
 > stable is about backporting _well tested_ patches from mainline.
 > 
 > If the stable request comes in from someone 5 minutes after the mainline submission
 > I don't see how that testing should happen.

And how many people have picked up on the fact that the fix in 2.6.22rc is busted
in the last week ?
Ie, we'd be waiting probably until after .22 goes out before we found out it's
still horked, and leaving .21.x busted for another three weeks.

If the functionality is completely busted in -stable, adding a patch that's
isolated to that component can't really make things much worse.
All we've done here is move the breakage.

	Dave

-- 
http://www.codemonkey.org.uk
