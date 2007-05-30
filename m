Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXE3TLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXE3TLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbXE3TLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:11:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbXE3TLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:11:39 -0400
Date: Wed, 30 May 2007 15:09:37 -0400
From: Bill Nottingham <notting@redhat.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, openib-general@openib.org,
       linux-kernel@vger.kernel.org
Subject: Re: dealing with gcc 'comparison is always false' warnings (was:
	[PATCH] drivers/infiniband: fix comparsion between unsigned and
	negative)
Message-ID: <20070530190937.GA5444@nostromo.devel.redhat.com>
Mail-Followup-To: Satyam Sharma <satyam.sharma@gmail.com>,
	Roland Dreier <rdreier@cisco.com>, openib-general@openib.org,
	linux-kernel@vger.kernel.org
References: <20070530080518.GA29195@nostromo.devel.redhat.com> <adazm3mqqh3.fsf@cisco.com> <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma (satyam.sharma@gmail.com) said: 
> But yes, the kind of "fixes" you pointed out that _remove_ these conditions
> are definitely *not* what we would want to do.

I can see that - but I think it should be at least be brought up for each
warning, to determine either:

1) if it should be ignored
2) if a signed type is actually intended
3) if the code should be elided

While not necessarily in the IB instances, there are cases where there
are entire blocks of code (with debugging output, error returns, etc)
that can never get run, and it may make sense to remove those.

Bill
