Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbXIQVY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbXIQVY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbXIQVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:24:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59819 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755400AbXIQVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:24:19 -0400
Date: Mon, 17 Sep 2007 14:24:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>
Subject: Re: [PATCH] Configurable reclaim batch size
In-Reply-To: <46EEE80D.6060808@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0709171423230.29704@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709141519230.14894@schroedinger.engr.sgi.com>
 <1189812002.5826.31.camel@lappy> <Pine.LNX.4.64.0709171053040.26860@schroedinger.engr.sgi.com>
 <20070917215615.685a5378@lappy> <46EEE80D.6060808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Balbir Singh wrote:

> Please do let me know if someone finds a good standard test for it or a
> way to stress reclaim. I've heard AIM7 come up often, but never been
> able to push it much. I should retry.

AIM7 does small computing loads reflecting an earlier time. I wish there 
was something better reflecting large computing loads of today. The tests 
that I know of require MPI and other libraries and are not that suitable 
for kernel hackers.

