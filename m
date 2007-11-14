Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbXKNCKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbXKNCKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761377AbXKNCFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55745 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761315AbXKNCFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:48 -0500
Date: Tue, 13 Nov 2007 18:05:48 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.180009.56326652.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711131803530.6713@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
 <20071113.173718.112153027.davem@davemloft.net>
 <Pine.LNX.4.64.0711131748570.6539@schroedinger.engr.sgi.com>
 <20071113.180009.56326652.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, David Miller wrote:

> The idea about doling out vmalloc space seemed the most promising.

Well that is basically the same as the virtual mode. Just ditch the 
fallback mode? vmalloc directly does not guarantee a fixed address.

