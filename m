Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbYCMTe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbYCMTe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYCMTeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:34:22 -0400
Received: from phunq.net ([64.81.85.152]:52005 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752203AbYCMTeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:34:21 -0400
From: Daniel Phillips <phillips@phunq.net>
To: tvrtko.ursulin@sophos.com
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 11:34:18 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <OFA00954A4.45F32CA2-ON8025740B.005D7B40-8025740B.005EECA6@sophos.com>
In-Reply-To: <OFA00954A4.45F32CA2-ON8025740B.005D7B40-8025740B.005EECA6@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131234.19303.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 10:16, tvrtko.ursulin@sophos.com wrote:
> can it support the "fast" block device from the pair to be smaller in 
> capacity but overall virtual device to still be as big as the backing 
> store?

It can't.  Since that problem is a strict superset of the one-to-one
problem that ramback solves, I thought it would make sense to work out
the bugs in ramback first before tackling the harder problem.

Daniel
