Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXK2GgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXK2GgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXK2Gf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:35:58 -0500
Received: from mx10.go2.pl ([193.17.41.74]:54767 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348AbXK2Gf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:35:58 -0500
Date: Thu, 29 Nov 2007 07:40:34 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: Question regarding mutex locking
Message-ID: <20071129064034.GB9536@ff.dom.local>
References: <474CF06C.8020208@lwfinger.net> <jemysy2y3y.fsf@sykes.suse.de> <474D8C22.7010902@lwfinger.net> <474DEF79.1080900@o2.pl> <20071128153312.14144472@freepuppy.rosehill>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128153312.14144472@freepuppy.rosehill>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 03:33:12PM -0800, Stephen Hemminger wrote:
...
> WTF are you teaching a lesson on how NOT to do locking?
> 
> Any code which has this kind of convoluted dependency on conditional
> locking is fundamentally broken.
> 

As a matter of fact I've been thinking, about one more Re: to myself
to point this all is a good example how problematic such solution
would be, but I've decided it's rather apparent. IMHO learning needs
bad examples too - to better understand why they should be avoided.

On the other hand, I've seen quite a lot of fundamentally right, but
practically broken code, so I'm not sure what's better. And, btw., I
guess this 'fundamentally broken' type of locking could be found in
the kernel too, but I'd prefer not too look after this now.

Thanks,
Jarek P.
