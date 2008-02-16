Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYBPRdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYBPRdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYBPRdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:33:32 -0500
Received: from 1wt.eu ([62.212.114.60]:1987 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbYBPRdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:33:31 -0500
Date: Sat, 16 Feb 2008 18:33:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Roel Kluin <12o3l@tiscali.nl>, geoffrey.levand@am.sony.com,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080216173315.GU8953@1wt.eu>
References: <47B70A61.9030306@tiscali.nl> <20080216092552.325e5726@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216092552.325e5726@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 09:25:52AM -0800, Arjan van de Ven wrote:
> On Sat, 16 Feb 2008 17:08:01 +0100
> Roel Kluin <12o3l@tiscali.nl> wrote:
> 
> > The patch below was not yet tested. If it's correct as it is, please
> > comment. ---
> > Fix Unlikely(x) == y
> > 
> 
> you found a great set of bugs..
> but to be honest... I suspect it's just best to remove unlikely altogether for these cases;
> unlikely() is almost a go-faster-stripes thing, and if you don't know how to use it you shouldn't
> be using it... so just removing it for all wrong cases is actually the best thing to do imo.

Well, eventhough the author may not know how to use it, "unlikely" at
least indicates the intention of the author, or his knowledge of what
should happen here. I'd suggest leaving it where it is because the
authot of this code is in best position to know that this branch is
unlikely to happen, eventhough he does not correctly use the macro.

Willy

