Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZHPVun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZHPVun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZHPVum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:50:42 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:61573 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbZHPVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:50:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKsbiEqrR7MV/2dsb2JhbAC6WIgtjnsFhBk
X-IronPort-AV: E=Sophos;i="4.43,391,1246838400"; 
   d="scan'208";a="368377170"
From: Roland Dreier <rdreier@cisco.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support
References: <200908122007.43522.ngupta@vflare.org>
	<20090813151312.GA13559@linux.intel.com>
	<20090813162621.GB1915@phenom2.trippelsdorf.de>
	<alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	<87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	<alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	<3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>
	<4A85E0DC.9040101@rtr.ca>
	<f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
	<20090814234539.GE27148@parisc-linux.org>
	<f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>
	<1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca>
	<1250344518.4159.4.camel@mulgrave.site>
	<20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
	<20090816083434.2ce69859@infradead.org>
	<1250437927.3856.119.camel@mulgrave.site>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 16 Aug 2009 14:50:40 -0700
In-Reply-To: <1250437927.3856.119.camel@mulgrave.site> (James Bottomley's
	message of "Sun, 16 Aug 2009 10:52:07 -0500")
Message-ID: <adavdkn2ztb.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Aug 2009 21:50:41.0204 (UTC) FILETIME=[993BEF40:01CA1EBB]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Well, yes and no ... a lot of SSDs don't actually implement NCQ, so the
 > impact to them will be less ... although I think enterprise class SSDs
 > do implement NCQ.

Really?  Which SSDs don't implement NCQ?

It seems that one couldn't keep the flash busy doing only one command at time.
