Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYJ3VVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYJ3VVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbYJ3VV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:21:29 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:52351 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbYJ3VV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:21:28 -0400
Date: Thu, 30 Oct 2008 14:21:21 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, tim@scalemp.com, shai@scalex86.org
Subject: Re: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030212121.GB6583@localdomain>
References: <20081030020203.GA12423@localdomain> <20081030132103.2daff1e1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030132103.2daff1e1@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 01:21:03PM -0700, Arjan van de Ven wrote:
>On Wed, 29 Oct 2008 19:02:03 -0700
>Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>well... technically the aliases are bad without PAT as well...
>

Hmm! Well, you mean if mtrr is used to change attributes?

I guess there is always a risk associated with luser space mmaping /dev/mem,
and we have CONFIG_STRICT_DEVMEM to avoid this in production.
However, for debugging tools, it is worth having the capability in _debug_
kernels and living with the risk IMHO.

Thanks,
Kiran
