Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbXLQTwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbXLQTwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXLQTkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:40:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53381 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763943AbXLQTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:40:41 -0500
Date: Mon, 17 Dec 2007 11:40:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>, davem@davemloft.net,
       andi@firstfloor.org, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [UDP6]: Counter increment on BH mode
In-Reply-To: <20071215184327.GA21434@elte.hu>
Message-ID: <Pine.LNX.4.64.0712171139220.12871@schroedinger.engr.sgi.com>
References: <474F7EE8.2040009@cn.fujitsu.com> <474F8255.5060501@cn.fujitsu.com>
 <20071130111949.GB28277@gerrit.erg.abdn.ac.uk> <20071201015438.GC26895@gondor.apana.org.au>
 <4753AE07.1040906@cn.fujitsu.com> <20071203113935.GA25124@gondor.apana.org.au>
 <20071203114912.GA4425@ms2.inr.ac.ru> <20071203115435.GA4202@gondor.apana.org.au>
 <20071203131723.GA30312@gondor.apana.org.au> <20071215135851.GA29063@gondor.apana.org.au>
 <20071215184327.GA21434@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu alloc patches also fix this issue one way (disabling preempt) or 
the other (atomic instruction that does not need disabling of 
preeemption).

