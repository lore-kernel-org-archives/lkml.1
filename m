Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXCPL2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXCPL2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbXCPL2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:28:54 -0400
Received: from ns.suse.de ([195.135.220.2]:43818 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbXCPL2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:28:54 -0400
From: Andi Kleen <ak@suse.de>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: [discuss] [PATCH] x86_64: fix cpu MHz reporting on constant_tsc cpus
Date: Fri, 16 Mar 2007 12:24:41 +0100
User-Agent: KMail/1.9.1
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
References: <20070313100043.GC21463@amd.com> <200703150001.09390.ak@suse.de> <20070315165047.GY21463@amd.com>
In-Reply-To: <20070315165047.GY21463@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161224.42006.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Yes. You are right. I will fix that and send a new version.  Thanks for
> the review.

I already fixed it up and fixed some other bugs. The changes to tsc_khz
in nmi.c were wrong because the performance counters don't tick 
at tsc frequency.

-Andi
