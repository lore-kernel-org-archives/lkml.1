Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZEDQGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZEDQGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEDQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:05:51 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:36001 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbZEDQFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:05:50 -0400
Date: Mon, 4 May 2009 11:54:53 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
In-Reply-To: <20090504152026.GO4173@lenovo>
Message-ID: <alpine.DEB.1.10.0905041148490.10044@qirst.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504141256.GK4173@lenovo> <alpine.DEB.1.10.0905041011200.17937@qirst.com> <20090504142903.GM4173@lenovo>
 <20090504152026.GO4173@lenovo>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Cyrill Gorcunov wrote:

> You know I only found a message in case if page is already
> not granted (ie NULL is going to be returned) and right
> before that we print a warning about that (nopage: label).
> Which means - no panic here and with (__GFP_NOFAIL | __GFP_REPEAT)
> just spinning around in attepmt to allocate new memory. And how
> to behave on atomic allocations. Almost give up... :)

Could you check for __GFP_FAIL|__GFP_REPEAT somewheres and panic? Not sure
if __GFP_REPEAT is the right second flag to use.

