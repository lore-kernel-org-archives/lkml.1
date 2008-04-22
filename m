Return-Path: <linux-kernel-owner+w=401wt.eu-S933735AbYDVXJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbYDVXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761962AbYDVXJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:09:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46266 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760013AbYDVXJI (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:09:08 -0400
Date: Wed, 23 Apr 2008 09:08:35 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: remove unused params from functions in xfs/quota/*
Message-ID: <20080422230835.GY108924158@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804221351.03885.vda.linux@googlemail.com> <200804221532.22701.vda.linux@googlemail.com> <200804221540.12382.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221540.12382.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 03:40:12PM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> This patch deals with remaining cases of unused parameters in fs/xfs/quota/*
> as far as I can see so far. The rest of unused parameters
> in fs/xfs/quota/* cannot be easily eliminated due to addresses
> of functions being taken.

I'd just kill the parameters to xfs_qm_hold_quotafs_ref and
xfs_qm_rele_quotafs_ref and I wouldn't worry about removingthe debug-only
id parameter to xfs_qm_dqread as it's not in a stack critical path.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
