Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbXCGMXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbXCGMXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXCGMXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:23:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15915 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbXCGMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:23:42 -0500
Date: Wed, 7 Mar 2007 04:22:24 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307122224.GP18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Nick Piggin <npiggin@suse.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	benh@kernel.crashing.org
References: <1173259942.6374.125.camel@twins> <20070307094503.GD8609@wotan.suse.de> <20070307100430.GA5080@wotan.suse.de> <1173262002.6374.128.camel@twins> <E1HOt96-0008V6-00@dorka.pomaz.szeredi.hu> <20070307102106.GB5555@wotan.suse.de> <1173263085.6374.132.camel@twins> <20070307103842.GD5555@wotan.suse.de> <1173264462.6374.140.camel@twins> <20070307110035.GE5555@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307110035.GE5555@wotan.suse.de>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:47:42AM +0100, Peter Zijlstra wrote:
>> Well, now they don't, but it could be done or even exploited as a DoS.

On Wed, Mar 07, 2007 at 12:00:36PM +0100, Nick Piggin wrote:
> But so could nonlinear page reclaim. I think we need to restrict nonlinear
> mappings to root if we're worried about that.

Please not root. The users really don't want to be privileged. UML
itself is at least partly for use as privilege isolation of the guest
workload. Oracle has some of the same concerns itself, which is part of
why it uses separate processes heavily, even: to isolate instances from
each other.


-- wli
