Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZLVIAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZLVIAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZLVIAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:00:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42220 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZLVIAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:00:11 -0500
Date: Tue, 22 Dec 2009 08:59:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091222075927.GC26467@elte.hu>
References: <4B1D4F29.8020309@gmail.com>
 <20091218215107.GA14946@elte.hu>
 <4B2F9582.5000002@gmail.com>
 <4B2F978D.7010602@redhat.com>
 <4B2F9C85.7070202@gmail.com>
 <4B2FA42F.3070408@codemonkey.ws>
 <4B2FA655.6030205@gmail.com>
 <4B2FAE7B.9030005@codemonkey.ws>
 <4B2FB3F1.5080808@gmail.com>
 <4B300EF8.8010602@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B300EF8.8010602@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> It's important to understand why one mechanism is better than another.  All 
> I'm looking for is a set of bullet points that say, vbus does this, 
> vhost-net does that, therefore vbus is better.  We would then either say, 
> oh, that's a good idea, let's change vhost-net to do that, or we would say, 
> hrm, well, we can't change vhost-net to do that because of some fundamental 
> flaw, let's drop it and adopt vbus.
> 
> It's really that simple :-)

That makes a lot of sense to me.

I think we better have damn good technical reasons before we encourage a fork 
of a subsystem within the kernel. Technical truth is not something we can 
'agree to disagree' on, and it is not something we can compromise on really.  

Both the host and the guest code is in Linux so adding another variant without 
that variant replacing the old one (on the spot or gradually) makes no 
technical sense.

Gregory, i'd suggest for you to shape this as a "this and this aspect of KVM 
needs to be replaced/fixed" list of items, as suggested by Anthony. In my 
experience the KVM folks are very approachable and very reasonable about 
addressing technical shortcomings and acting upon feedback (and are happily 
accepting code as well) - so to the extent there's room for improvement here 
it should be done by shaping KVM, not by forking and rebranding it.

	Ingo
