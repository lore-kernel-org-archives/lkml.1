Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbXHFTS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbXHFTS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbXHFTSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:18:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53100 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755467AbXHFTSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:18:14 -0400
Date: Mon, 6 Aug 2007 12:18:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Mel Gorman <mel@skynet.ie>,
       Lee.Schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
In-Reply-To: <20070806121558.e1977ba5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708061216570.7603@schroedinger.engr.sgi.com>
References: <20070802172118.GD23133@skynet.ie> <200708040002.18167.ak@suse.de>
 <20070806121558.e1977ba5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Andrew Morton wrote:

> If correct, I would suggest merging the horrible hack for .23 then taking
> it out when we merge "grouping pages by mobility".  But what if we don't do
> that merge?

Take the horrible hack for .23.

For .24 either merge the mobility or get the other solution that Mel is 
working on. That solution would only use a single zonelist per node and 
filter on the fly. That may help performance and also help to make memory 
policies work better.
