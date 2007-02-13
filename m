Return-Path: <linux-kernel-owner+w=401wt.eu-S1751356AbXBMRth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbXBMRth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXBMRth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:49:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:54512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXBMRtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:49:36 -0500
From: Andi Kleen <ak@suse.de>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
Date: Tue, 13 Feb 2007 18:45:05 +0100
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com> <45D1F0B1.3020508@mbligh.org>
In-Reply-To: <45D1F0B1.3020508@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131845.05913.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Your description of the node is correct, it's an arbitrary container of
> one or more resources. Not only is this definition flexible, it's also
> very useful, for memory hotplug, odd types of NUMA boxes, etc.

I must disagree here. Special cases are always dangerous especially
if they are hard to regression test. I made this discovery the hard
way on x86-64 ... It's best to eliminate them in the first place,
otherwise they will later come back and bite you when you don't expect it.

Adding NULL tests all over mm for this would seem like a clear case
of this to me.

-Andi
