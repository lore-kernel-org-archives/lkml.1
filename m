Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYJGXbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYJGXbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYJGXbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:31:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47772 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbYJGXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:31:01 -0400
Date: Wed, 8 Oct 2008 01:37:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Provide rdtscll() asm/msr.h for user space
Message-ID: <20081007233709.GW20740@one.firstfloor.org>
References: <20081007143.793379346@firstfloor.org> <48EBD555.9060104@kernel.org> <20081007231149.GT20740@one.firstfloor.org> <48EBEFCC.4090302@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EBEFCC.4090302@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 04:25:00PM -0700, H. Peter Anvin wrote:
> >Anyways if you insist I can probably deal without
> >but I (and likely others) would think something nasty about you every time 
> >I have to cut'n'paste that code again. Do you really want to risk that? @)
> 
> If you're really incapable of maintaining a single user-mode header file 
> with a handful of one-liners in a sane way, then definitely.

These are typical benchmark or test programs which I like to write with 
as little dependencies as possible because they compile/run on all kinds
of systems with often dubious setup.

The other issue is that everyone will have to do this now, which just
seems wrong to me. 

-Andi (who never got this strange meme which is floating around
in the kernel community for some time that cut'n'pasting interfaces
into user programs is a sane thing. To me it seems insane.)

-- 
ak@linux.intel.com
