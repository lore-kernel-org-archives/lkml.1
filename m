Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbYEGEiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbYEGEiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761677AbYEGEht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:37:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:40115 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbYEGEhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:37:48 -0400
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080506212022.3d2eddeb@infradead.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	 <20080506143936.6357e578.akpm@linux-foundation.org>
	 <20080506.144301.233784820.davem@davemloft.net>
	 <20080506145608.565b61bf.akpm@linux-foundation.org>
	 <20080506210055.75e2f881@infradead.org>
	 <20080506211233.f050fd41.akpm@linux-foundation.org>
	 <20080506211552.6af7cecc@infradead.org>
	 <20080506212022.3d2eddeb@infradead.org>
Content-Type: text/plain
Date: Wed, 07 May 2008 14:37:25 +1000
Message-Id: <1210135045.21644.204.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 21:20 -0700, Arjan van de Ven wrote:
> > 
> > > Which should be called WARN, but of course 12,000,000 drivers have
> > > gone and screwed that up with indiscriminate namespace poaching.
> > 
> 
> seems to be only 5 of them; we can move those aside I suppose

In the case of radeonfb, don't bother. Those EDID files aren't used
by anything afaik.

Ben.


