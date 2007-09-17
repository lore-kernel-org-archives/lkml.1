Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbXIQUGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbXIQUGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbXIQUFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:05:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53548 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757989AbXIQUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:05:43 -0400
Date: Mon, 17 Sep 2007 13:05:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [PATCH] Configurable reclaim batch size
In-Reply-To: <20070917215615.685a5378@lappy>
Message-ID: <Pine.LNX.4.64.0709171304310.28864@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709141519230.14894@schroedinger.engr.sgi.com>
 <1189812002.5826.31.camel@lappy> <Pine.LNX.4.64.0709171053040.26860@schroedinger.engr.sgi.com>
 <20070917215615.685a5378@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007, Peter Zijlstra wrote:

> > Tried to run AIM7 but the improvements are in the noise. I need a tests 
> > that really does large memory allocation and stresses the LRU. I could 
> > code something up but then Lee's patch addresses some of the same issues.
> > Is there any standard test that shows LRU handling regressions?
> 
> hehe, I wish. I was just hoping you'd done this patch as a result of an
> actual problem and not a hunch.

It was Andrew's hunch. I'd rather see Lee's approach go forward because 
I think it has the potential of solving the issue in a more general way. 
If I get some spare time with a problem system then I will test the patch.

