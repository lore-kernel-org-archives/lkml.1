Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab0BDRPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:15:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753086Ab0BDRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:15:43 -0500
Date: Thu, 4 Feb 2010 09:15:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
In-Reply-To: <20100204170826.GA16397@elte.hu>
Message-ID: <alpine.LFD.2.00.1002040913420.3707@localhost.localdomain>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie> <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie> <20100202081727.GA6788@elte.hu> <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com> <20100202154656.GD27314@elte.hu>
 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com> <20100204062619.GA29154@elte.hu> <20100204071705.GA28403@elte.hu> <20100204164859.GA17878@srcf.ucam.org> <20100204170826.GA16397@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Ingo Molnar wrote:
> 
> Well, once i applied the revert i got no more hangs or crashes today, in lots 
> of bootups. This is fully repeatable - if i re-apply that commit with the 
> config i sent the hang happens again.

But that's just because when it was in staging, you'd never enable it, 
right? Because your config generator always turns off staging stuff. IOW, 
it's not the code - it's more an interaction with how your test-bed works.

			Linus
