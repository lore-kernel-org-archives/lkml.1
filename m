Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbZABW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbZABW0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZABW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:26:38 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:15026 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZABW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:26:36 -0500
X-IronPort-AV: E=Sophos;i="4.36,319,1228089600"; 
   d="scan'208";a="119463507"
From: Roland Dreier <rdreier@cisco.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs for mainline
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	<20081231104533.abfb1cf9.akpm@linux-foundation.org>
	<1230765549.7538.8.camel@think.oraclecorp.com>
	<87r63ljzox.fsf@basil.nowhere.org>
	<1230924749.7538.35.camel@think.oraclecorp.com>
	<20090102210104.GC496@one.firstfloor.org>
	<1230932112.7538.82.camel@think.oraclecorp.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 Jan 2009 14:26:34 -0800
In-Reply-To: <1230932112.7538.82.camel@think.oraclecorp.com> (Chris Mason's
	message of "Fri, 02 Jan 2009 16:35:12 -0500")
Message-ID: <adaocyppco5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jan 2009 22:26:34.0597 (UTC) FILETIME=[2B662150:01C96D29]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > > I don't disagree, please do keep in mind that I'm not suggesting anyone
 > > > use this in production yet.

 > > When it's in mainline I suspect people will start using it for that.

 > I think the larger question here is where we want development to happen.
 > I'm definitely not pretending that btrfs is perfect, but I strongly
 > believe that it will be a better filesystem if the development moves to
 > mainline where it will attract more eyeballs and more testers.

One possibility would be to mimic ext4 and register the fs as "btrfsdev"
until it's considered stable enough for production.  I agree with the
consensus that we want to use the upstream kernel as a nexus for
coordinating btrfs development, so I don't think it's worth waiting a
release or two to merge something.

 - R.
