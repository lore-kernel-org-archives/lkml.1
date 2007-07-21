Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXGUVHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXGUVHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGUVHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:07:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbXGUVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:07:09 -0400
Subject: Re: [PATCH 1/3] readahead: drop behind
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <1185051551.28982.4.camel@perkele>
References: <20070721210005.000228000@chello.nl>
	 <20070721210051.975382000@chello.nl>  <1185049747.27915.8.camel@perkele>
	 <1185050276.5652.23.camel@lappy>  <1185051551.28982.4.camel@perkele>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 23:06:39 +0200
Message-Id: <1185051999.5652.25.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 16:59 -0400, Eric St-Laurent wrote:
> > They are against git of a few hours ago and the latest readahead patches
> > from Wu (which don't apply cleanly either, but the rejects are trivial).
> > 
> > > It would be useful to have a temporary /proc tunable to enable/disable
> > > the heuristic to help test the effects.
> > 
> > Right, I had such a patch somewhere,.. won't apply cleanly but should be
> > obvious..
> 
> Thanks, I will merge theses and report back with some results.
> 
> After copying large files, I find my system sluggish. I hope your
> changes will help.

Yeah, copying will still hurt. This will only help reading large files,
not writing :-/

For that I still need an inspiring idea.

