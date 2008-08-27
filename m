Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYH0Wh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYH0Wh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYH0WhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:37:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55008 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYH0WhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:37:19 -0400
Date: Thu, 28 Aug 2008 00:39:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, rick.jones2@hp.com, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, denys@visp.net.lb, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080827223952.GE26610@one.firstfloor.org>
References: <87vdxmr53f.fsf@basil.nowhere.org> <48B57BD3.5050206@hp.com> <20080827162735.GW26610@one.firstfloor.org> <20080827.151824.14173512.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827.151824.14173512.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 03:18:24PM -0700, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Wed, 27 Aug 2008 18:27:35 +0200
> 
> > > Those banks really want to crank down on latency - to the point they 
> > > start disabling interrupt coalescing.  I bet they'd toss anything out 
> > > they could to shave another microsecond.
> > 
> > This change would actually likely lower their latency.
> 
> They want the timestamps, but they want it to match when the packet
> arrived at their system as closely as is reasonably possible.

Then they should use hardware time stamps which are increasingly 
available (e.g. current Intel e1000 design has them and I expect
others too). 

-Andi

