Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYJFWgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYJFWgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 18:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYJFWfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 18:35:53 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:12706 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYJFWfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 18:35:53 -0400
X-IronPort-AV: E=Sophos;i="4.33,369,1220227200"; 
   d="scan'208";a="47939983"
From: Roland Dreier <rdreier@cisco.com>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: ericvh@gmail.com, linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org,
       rminnich@dancer.ca.sandia.gov, lionkov@lanl.gov
Subject: Re: [PATCH 01/03] 9prdma: RDMA Transport Support for 9P
References: <1222906119-14310-1-git-send-email-tom@opengridcomputing.com>
	<1222906119-14310-2-git-send-email-tom@opengridcomputing.com>
	<adaod23d1if.fsf@cisco.com> <48EA549E.1050001@opengridcomputing.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 06 Oct 2008 15:35:51 -0700
In-Reply-To: <48EA549E.1050001@opengridcomputing.com> (Tom Tucker's message of
	"Mon, 06 Oct 2008 13:10:38 -0500")
Message-ID: <adavdw5nygo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Oct 2008 22:35:51.0916 (UTC) FILETIME=[E33C42C0:01C92803]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Is your protocol documented anywhere?  It seems npfs has support for the
 > > same transport.

 > When using SEND/RECV, there isn't a protocol other than 9P
 > itself. Once we add RDMA ops, one will be required to exchange RKEY,
 > etc... But maybe I don't understand the question?

No, that makes sense.  I don't know that much about 9p but I guess it's
fairly transport agnostic, so if you're just sending/receiving standard
9p messages then there's probably nothing to exchange.

 - R.
