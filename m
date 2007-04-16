Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXDPFpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXDPFpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXDPFpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:45:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXDPFpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:45:04 -0400
Date: Mon, 16 Apr 2007 01:44:59 -0400
From: Dave Jones <davej@redhat.com>
To: Zach Carter <linux@zachcarter.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: BUG:  Bad page state errors during kernel make
Message-ID: <20070416054459.GA7528@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Zach Carter <linux@zachcarter.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <4622EDD3.9080103@zachcarter.com> <20070416035603.GD21217@redhat.com> <46230A3A.8060907@zachcarter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46230A3A.8060907@zachcarter.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 10:31:38PM -0700, Zach Carter wrote:
 > 
 > Dave Jones wrote:
 > > On Sun, Apr 15, 2007 at 08:30:27PM -0700, Zach Carter wrote:
 > >  > list_del corruption. prev->next should be c21a4628, but was e21a4628
 > > 
 > > 'c' became 'e' in that last address. A single bit flipped.
 > > Given you've had this for some time, this smells like a hardware problem.
 > > memtest86+ will probably show up something.
 > 
 > Hum.   I forgot to mention in my report that I had already run thru 10 clean passes with memtest86+
 > 
 > Do you think there might be other bad hw, or another explanation?

Maybe.  I've seen underpowered PSUs, bad motherboard capacitors, and
even poor ventilation caused by clogged fans causing similar bugs.

It could also actually be a software fault, but it's surprising that
you hit it so easily, for so long, and no-one else seems to be
equally as affected.

	Dave

-- 
http://www.codemonkey.org.uk
