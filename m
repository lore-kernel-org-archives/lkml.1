Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbXKBCvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbXKBCvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXKBCvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:51:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46869
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbXKBCvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:51:04 -0400
Date: Thu, 01 Nov 2007 19:51:01 -0700 (PDT)
Message-Id: <20071101.195101.42788898.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711011759400.24589@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
	<20071101.155805.65012933.davem@davemloft.net>
	<Pine.LNX.4.64.0711011759400.24589@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 1 Nov 2007 18:06:17 -0700 (PDT)

> A reasonable implementation for 64 bit is likely going to depend on 
> reserving some virtual memory space for the per cpu mappings so that they 
> can be dynamically grown up to what the reserved virtual space allows.
> 
> F.e. If we reserve 256G of virtual space and support a maximum of 16k cpus 
> then there is a limit on the per cpu space available of 16MB.

Now that I understand your implementation better, yes this
sounds just fine.
