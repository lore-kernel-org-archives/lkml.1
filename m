Return-Path: <linux-kernel-owner+w=401wt.eu-S938560AbXG1ABL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938560AbXG1ABL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938153AbXG1AA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:00:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38610 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938151AbXG1AA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:00:58 -0400
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources
	(was: updatedb)
From: Arjan van de Ven <arjan@infradead.org>
To: grundig <grundig@teleline.es>
Cc: Indan Zupancic <indan@nul.nu>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070728013251.7c110223.grundig@teleline.es>
References: <200707272243.02336.a1426z@gawab.com>
	 <1185568498.2711.5.camel@laptopd505.fenrus.org>
	 <52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
	 <1185573974.2711.8.camel@laptopd505.fenrus.org>
	 <20070728013251.7c110223.grundig@teleline.es>
Content-Type: text/plain; charset=UTF-8
Organization: Intel International BV
Date: Fri, 27 Jul 2007 16:59:01 -0700
Message-Id: <1185580741.2711.11.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-28 at 01:34 +0200, grundig wrote:
> El Fri, 27 Jul 2007 15:06:14 -0700, Arjan van de Ven <arjan@infradead.org> escribió:
> 
> > how do you know there will be other activity? You start the IO and that
> > basically blacks out the disk for 5 to 10 ms. If the "real" IO gets
> > submitted in that time you add latency. You cannot predict that IO
> > happening or not happening.
> 
> If there hasn't be much IO for some time, it looks quite reasonable to expect
> that there won't be more in the near future. As most of heuristics can fail

exactly this was my point: just saying "there are no downsides" isn't
true.

> There's an old saying that says something like "an open source project starts
> dying when new people can't participate in the project no matter how hard
> they try". It's hard to understand why there's so many people opposing to
> this when other more controversial features are merged much faster, (like, fe. 
> the UIO driver framework). 

I'm not opposing this or cheering for it. I'm opposing blindly saying
"there are no downsides". This needs showing with data at minimum, and
my reading of this saga seems to suggest data is the bit that is lacking
from the start...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

