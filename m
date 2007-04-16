Return-Path: <linux-kernel-owner+w=401wt.eu-S1031036AbXDPXmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031036AbXDPXmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 19:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031035AbXDPXmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 19:42:21 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:1858 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031030AbXDPXmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 19:42:20 -0400
Date: Tue, 17 Apr 2007 09:43:48 +1000
From: CaT <cat@zip.com.au>
To: Michael Chan <mchan@broadcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Jean-Daniel Pauget <jd@disjunkt.com>
Subject: Re: intermittant petabyte usage reported with broadcom nic
Message-ID: <20070416234348.GF8345@zip.com.au>
References: <20070402014319.GA8345@zip.com.au> <20070402001300.3b66007d.akpm@linux-foundation.org> <20070402074108.GB8345@zip.com.au> <1176596401.5847.7.camel@dell> <1176750651.6217.3.camel@dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176750651.6217.3.camel@dell>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 12:10:51PM -0700, Michael Chan wrote:
> On Sat, 2007-04-14 at 17:20 -0700, Michael Chan wrote:
> 
> > I also like Andi's idea of using change_page_attr() to isolate the
> > problem.  I'll try to send you a debug patch in the next few days to try
> > that out.  Thanks.
> 
> Here's the debug patch for x86 only that will change the statistics
> memory block to read-only.  If the kernel is corrupting it, you should
> get a page fault that will crash the system.  If you continue to see
> bogus counters, it is definitely a firmware or hardware problem.  Please
> try it and let me know.  Thanks.

Ahh. Would truly love to but the moment you said 'crash the system' I
had to bail. These boxes are in production and as such a crash would be,
shall we say, unwelcome. I might be able to fenagle something but I
very-much doubt it.

Perhaps Jean-Daniel, who is also experiencing this problem and seemingly
more frequently then I, has a box that he could run your patch on. I
think we both run pretty-much the same hardware (Dell [12]950s). I've
CCed him.

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
