Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbYAWVXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbYAWVXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYAWVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:23:43 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:59260 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYAWVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:23:42 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.25
X-Message-Flag: Warning: May contain useful information
References: <ada7ii8xaao.fsf@cisco.com> <20080121100151.GD5333@infradead.org>
	<adad4rttthr.fsf@cisco.com> <20080123055014.GA9256@infradead.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 23 Jan 2008 13:23:34 -0800
In-Reply-To: <20080123055014.GA9256@infradead.org> (Christoph Hellwig's message of "Wed, 23 Jan 2008 05:50:14 +0000")
Message-ID: <ada1w88qlrd.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jan 2008 21:23:35.0278 (UTC) FILETIME=[363C10E0:01C85E06]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > be improved (sparse endianness annotation,

 > that's a blocker for sure.  No new code that's not sparse clean, please.

I have to disagree -- remember how strongly Linus pushed to merge
hardware drivers early?  the code in question will not run unless you
have the hardware it drives, and that hardware is useless without the
code.  And *something* is better for users than nothing.

Anyway I don't think the endianness annotations are that hard so it
will probably show up soon.

 - R.
