Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXHEPCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXHEPCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXHEPCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:02:13 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44771 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbXHEPCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:02:11 -0400
Date: Sun, 5 Aug 2007 19:01:55 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage.
Message-ID: <20070805150154.GA32132@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708031741.18404.phillips@phunq.net> <20070804164438.GC14175@2ka.mipt.ru> <200708050106.58383.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708050106.58383.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 01:06:58AM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> > DST original code worked as device mapper plugin too, but its two
> > additional allocations (io and clone) per block request ended up for
> > me as a show stopper.
> 
> Ah, sorry, I misread.  A show stopper in terms of efficiency, or in 
> terms of deadlock?

At least as in terms of efficiency. Device mapper lives in happy world
where memory does not end and allocations are fast.

-- 
	Evgeniy Polyakov
