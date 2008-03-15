Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYCOX60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYCOX60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 19:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYCOX5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 19:57:53 -0400
Received: from khc.piap.pl ([195.187.100.11]:40448 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbYCOX5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 19:57:49 -0400
To: david@lang.hm
Cc: Daniel Phillips <phillips@phunq.net>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net>
	<200803151417.13899.phillips@phunq.net>
	<20080315215427.GC13012@1wt.eu>
	<200803151533.10797.phillips@phunq.net>
	<alpine.DEB.1.00.0803151540150.22040@asgard.lang.hm>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 16 Mar 2008 00:57:47 +0100
In-Reply-To: <alpine.DEB.1.00.0803151540150.22040@asgard.lang.hm> (david@lang.hm's message of "Sat\, 15 Mar 2008 16\:22\:20 -0700 \(PDT\)")
Message-ID: <m3r6eb1qx0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> dynamic ram needs a preocessor
> running to access the ram continuously to refresh it.

Actually modern DRAM can be put into "self refresh" mode which don't
need (nor allow) any external accesses. Not very practical in typical
PC case, though I think suspend to RAM uses it. Could be used for
battery - backed RAID/disk controller as well.

Obviously it changes nothing WRT ramback.
-- 
Krzysztof Halasa
