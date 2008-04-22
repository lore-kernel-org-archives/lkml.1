Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbYDVWsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbYDVWsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbYDVWrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:47:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51909 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755320AbYDVWrx (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:47:53 -0400
Date: Wed, 23 Apr 2008 08:47:21 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: #define out unused parameters for seven functions in xfs_trans.h
Message-ID: <20080422224721.GX108924158@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804221216.25905.vda.linux@googlemail.com> <200804221320.54147.vda.linux@googlemail.com> <200804221351.03885.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221351.03885.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:51:03PM +0200, Denys Vlasenko wrote:
> [ resend: now with patch attached! :) ]
> 
> Hi David,
> 
> Seven xfs_trans_XXX functions declared in xfs_trans.h
> are not using "tp" parameter in non-debug builds,
> but it still takes stack space since these functions
> are not static and gcc cannot optimize it out.

Same as my last comments - I don't think the savings are
worth the additional clutter it introduces.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
