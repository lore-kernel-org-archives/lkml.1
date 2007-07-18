Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbXGRDXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbXGRDXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 23:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXGRDXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 23:23:40 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:44719 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXGRDXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 23:23:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAHMknUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,548,1175497200"; 
   d="scan'208"; a="504286534:sNHT27300232"
To: "Or Gerlitz" <or.gerlitz@gmail.com>
Cc: "Sean Hefty" <mshefty@ichips.intel.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<4696D1F3.2040507@ichips.intel.com>
	<15ddcffd0707172020j5b68fcb2v7d3ca77863998020@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 20:23:38 -0700
In-Reply-To: <15ddcffd0707172020j5b68fcb2v7d3ca77863998020@mail.gmail.com> (Or Gerlitz's message of "Wed, 18 Jul 2007 06:20:15 +0300")
Message-ID: <adaabtuo0n9.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2007 03:23:38.0524 (UTC) FILETIME=[08494DC0:01C7C8EB]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > But to be fair, it will be difficult to enable both QoS and local PR
 > > caching.  To me, this would be the strongest reason against using it.
 > > However, QoS places additional burden on the SA, which will make scaling
 > > even more challenging.
 > 
 > my understanding is that the local sa does a path-query where all the fields
 > except for the SGID are wildcard-ed. This means we expect the result to be a
 > table of all the paths from this port to every other port on the fabrics for
 > every pkey which this port is a member of etc, correct?
 > 
 > How do you plug here  the QoS concept of SID in the path query? are you
 > expecting the SA to realize what are all the services for which this port is
 > a "member"? does the proposed definision for QoS management at the SA
 > defines "services per gids" isn't it "what SL to user per Service"?

Or, thanks for rescuing this post.

I think this is an important question.  If we merge the local SA
stuff, then are we creating a problem for dealing with QoS?  Are we
going to have to revert the local SA stuff once the QoS stuff is
available?  Or is there at least a sketch of a plan on how to handle
this?

 - R.
