Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbXFYUhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbXFYUhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXFYUh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:37:29 -0400
Received: from ns1.suse.de ([195.135.220.2]:35788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXFYUh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:37:28 -0400
From: Andi Kleen <ak@suse.de>
To: eranian@hpl.hp.com
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Date: Mon, 25 Jun 2007 22:36:40 +0200
User-Agent: KMail/1.9.1
Cc: b.steinbrink@gmx.de, ingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com
References: <20070618103214.GA12045@atjola.homenet> <200706252136.18366.ak@suse.de> <20070625200158.GC12139@frankl.hpl.hp.com>
In-Reply-To: <20070625200158.GC12139@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706252236.41004.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I looked at the code I have in my tree coming from Bjon's patches and
> I am a bit confused by the flow for probing as well.

Yes, it's a little risky. Perhaps it's better to readd the separate CPU switch
from .21 there again for 2.6.22. Ugly, but should be safe

-Andi
