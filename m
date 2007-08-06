Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbXHFUcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbXHFUcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbXHFUby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:31:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:37292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902AbXHFUbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:31:53 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Apply memory policies to top two highest zones when highest zone is ZONE_MOVABLE
Date: Mon, 6 Aug 2007 22:31:49 +0200
User-Agent: KMail/1.9.6
Cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070802172118.GD23133@skynet.ie> <200708040002.18167.ak@suse.de> <20070806121558.e1977ba5.akpm@linux-foundation.org>
In-Reply-To: <20070806121558.e1977ba5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062231.49247.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If correct, I would suggest merging the horrible hack for .23 then taking
> it out when we merge "grouping pages by mobility".  But what if we don't do
> that merge?

Or disable ZONE_MOVABLE until it is usable? I don't think we have the
infrastructure to really use it anyways, so it shouldn't make too much difference
in terms of features. And it's not that there is some sort of deadline
around for it. 

Or mark it CONFIG_EXPERIMENTAL with a warning that it'll break NUMA. But disabling 
is probably better.

Then for .24 or .25 a better solution can be developed.

I would prefer that instead of merging bandaid horrible hacks -- they have
a tendency to stay around.

-Andi
