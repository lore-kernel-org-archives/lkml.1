Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbXHBJy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbXHBJy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXHBJyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:54:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:52780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbXHBJyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:54:17 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
References: <46B1988C.3090302@t-online.de>
	<20070802015248.45a40717.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Aug 2007 12:48:49 +0200
In-Reply-To: <20070802015248.45a40717.akpm@linux-foundation.org>
Message-ID: <p731wemnre6.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> I didn't understand the arguments either, actually.

The issue is that you can actually kill hardware by setting this wrong.
We've had such cases where trip point problems eventually lead
to overheated laptops with hard disks dying etc. 

Also it runs the system out of spec and is similar to overclocking
which we also do not support.
 
> Here we had obviously-useful-to-you functionality which was taken away
> without, afaik, providing any alternative.

I don't think it's that unreasonable to require source code modifications
for anything that can kill hardware. At least that raises the barrier
a bit and hopefully ensures people think twice about it and then really
only blame themselves if anything goes wrong.

-Andi
