Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYAIHWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYAIHWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYAIHWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:22:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52156
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbYAIHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:22:24 -0500
Date: Tue, 08 Jan 2008 23:22:23 -0800 (PST)
Message-Id: <20080108.232223.211829980.davem@davemloft.net>
To: hch@lst.de
Cc: airlied@linux.ie, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       ak@suse.de, pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
 achitectures and kill notifier cruft"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080109071727.GA10695@lst.de>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
	<20080109071727.GA10695@lst.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 9 Jan 2008 08:17:27 +0100

> NACK.   If you want to do it you'll need a much better reason and an
> in-tree user.  And if you want to redo it it should be available for
> all platforms with a consistant API.

I majorly NACK this as well, we don't want to bring this thing
back especially for specialized debugging hacks.

You can set a kprobe on the x86 fault handler to do things like
mmiotrace.
