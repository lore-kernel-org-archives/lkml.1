Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXDTKQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXDTKQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423032AbXDTKQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:16:20 -0400
Received: from mx10.go2.pl ([193.17.41.74]:32804 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030419AbXDTKQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:16:19 -0400
Date: Fri, 20 Apr 2007 12:21:57 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070420102157.GD1695@ff.dom.local>
References: <20070419065404.GB1782@ff.dom.local> <20070419144618.GG32602149@melbourne.sgi.com> <20070420081325.GB1695@ff.dom.local> <20070420085354.GP32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420085354.GP32602149@melbourne.sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 06:53:54PM +1000, David Chinner wrote:
...
> Yes, after spending another two hours working out why my fix was
> then hanging in cancel_rearming_delayed_work() I was a little bit
> annoyed at the now obviously misleading comment. Five minutes later

I agree with your feelings, but strictly speaking it's not "obviously
misleading":

" * cancel_rearming_delayed_work - reliably kill off a delayed
keventd work whose handler rearms the delayed work."

And all your rearmed works were, probably, reliably killed!

> I'd fixed the bug properly. A better comment would have saved me two
> hours of wasted time.....

It seems to be an Achilles' heel of linux... 

Regards,
Jarek P.
