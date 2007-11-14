Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbXKNCCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbXKNCCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbXKNCCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:02:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32804
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbXKNCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:01:59 -0500
Date: Tue, 13 Nov 2007 18:01:58 -0800 (PST)
Message-Id: <20071113.180158.169883244.davem@davemloft.net>
To: clameter@sgi.com
Cc: andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711131756180.6631@schroedinger.engr.sgi.com>
References: <p73wssly6sr.fsf@bingen.suse.de>
	<20071113.175208.168903694.davem@davemloft.net>
	<Pine.LNX.4.64.0711131756180.6631@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 13 Nov 2007 17:57:15 -0800 (PST)

> Hmmmm. cpu_alloc really does not need zeroed data. Just an address
> fixed by the compiler where stuff can be put. Can the loader do that
> somehow?

Yes, and I think IA64 uses such a scheme for it's 64KB fixed
per-cpu TLB mapping thing doesn't it?
