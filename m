Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbXHaVnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbXHaVnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbXHaVne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:43:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717AbXHaVnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:43:32 -0400
Date: Fri, 31 Aug 2007 22:41:37 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Jens Axboe <jens.axboe@oracle.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: [1/1] Block device throttling [Re: Distributed storage.]
Message-ID: <20070831214137.GD30122@agk.fab.redhat.com>
Mail-Followup-To: Daniel Phillips <phillips@phunq.net>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>, Neil Brown <neilb@suse.de>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708281408.06618.phillips@phunq.net> <20070829085331.GA16607@2ka.mipt.ru> <200708301620.37965.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708301620.37965.phillips@phunq.net>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 04:20:35PM -0700, Daniel Phillips wrote:
> Resubmitting a bio or submitting a dependent bio from 
> inside a block driver does not need to be throttled because all 
> resources required to guarantee completion must have been obtained 
> _before_ the bio was allowed to proceed into the block layer.

I'm toying with the idea of keeping track of the maximum device stack
depth for each stacked device, and only permitting it to increase in
controlled circumstances.

Alasdair
-- 
agk@redhat.com
