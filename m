Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0BDRIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:08:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab0BDRIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:08:44 -0500
Date: Thu, 4 Feb 2010 18:08:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204170826.GA16397@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
 <20100202154656.GD27314@elte.hu>
 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
 <20100204062619.GA29154@elte.hu>
 <20100204071705.GA28403@elte.hu>
 <20100204164859.GA17878@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204164859.GA17878@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Feb 04, 2010 at 08:17:05AM +0100, Ingo Molnar wrote:
> 
> > btw., i just found another bug activated via this same commit, a boot 
> > hang after DRM init:
> 
> The commit in question didn't cause the hang, so reverting it isn't the 
> appropriate fix.

Well, once i applied the revert i got no more hangs or crashes today, in lots 
of bootups. This is fully repeatable - if i re-apply that commit with the 
config i sent the hang happens again.

	Ingo
