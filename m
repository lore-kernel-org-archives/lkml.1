Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYKLAp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYKLAp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYKLA3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:29:23 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:45349 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYKLA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:29:21 -0500
Date: Tue, 11 Nov 2008 18:28:57 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       travis@sgi.com, sfr@canb.auug.org.au, vegard.nossum@gmail.com
Subject: Re: [patch 0/7] cpu alloc stage 2
In-Reply-To: <20081111155611.93b978df.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811111827370.31625@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081111155611.93b978df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Andrew Morton wrote:

> It all looks very nice to me.  It's a shame about the lack of any
> commonality with local_t though.

At the end of the full patchset local_t is no more because cpu ops can
completely replace all use cases for local_t.

