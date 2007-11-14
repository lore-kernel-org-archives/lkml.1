Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbXKNETL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbXKNETL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXKNESz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:18:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754266AbXKNESy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:18:54 -0500
Date: Tue, 13 Nov 2007 20:18:53 -0800 (PST)
Message-Id: <20071113.201853.40241484.davem@davemloft.net>
To: clameter@sgi.com
Cc: andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711132011060.7528@schroedinger.engr.sgi.com>
References: <20071113.031510.151440585.davem@davemloft.net>
	<p73wssly6sr.fsf@bingen.suse.de>
	<Pine.LNX.4.64.0711132011060.7528@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 13 Nov 2007 20:15:55 -0800 (PST)

> Guess I need also to add an arch configuration guide to V2 as well so that 
> the other arches can do similar tricks and emphasize that the static 
> default that requires bss is only suitable for small systems.

I'm going to be against your changes until you implement
a real fix for the BSS bloat problems.

It's worse than the per-cpu allocator we have now, much
worse.
