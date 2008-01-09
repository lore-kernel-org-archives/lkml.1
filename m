Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYAIHXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYAIHXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYAIHXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:23:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33621
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbYAIHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:23:12 -0500
Date: Tue, 08 Jan 2008 23:23:11 -0800 (PST)
Message-Id: <20080108.232311.79648776.davem@davemloft.net>
To: hch@lst.de
Cc: airlied@linux.ie, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       ak@suse.de, pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
 achitectures and kill notifier cruft"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080109071945.GB10695@lst.de>
References: <20080108192951.a4dc394f.akpm@linux-foundation.org>
	<alpine.DEB.0.82.0801090346370.9570@skynet.skynet.ie>
	<20080109071945.GB10695@lst.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 9 Jan 2008 08:19:45 +0100

> On Wed, Jan 09, 2008 at 03:55:20AM +0000, Dave Airlie wrote:
> > now because Linus said send him a patch to revert regressions rather than 
> > just complain,
> 
> this is not a regression by any definition.  You were abusing exported
> symbols for out of tree junk, so you'll lose.

And furthermore, they don't even need it, use a kprobe.
