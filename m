Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbXFSQtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbXFSQtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbXFSQs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:48:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:44125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbXFSQsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:48:55 -0400
From: Andi Kleen <ak@suse.de>
To: prasanna@in.ibm.com
Subject: Re: [patch 1/2] kprobes i386 quick fix mark-ro-data
Date: Tue, 19 Jun 2007 18:47:53 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, ananth@in.ibm.com
References: <20070615202310.178466032@polymtl.ca> <200706182132.56559.ak@suse.de> <20070619100644.GA5478@in.ibm.com>
In-Reply-To: <20070619100644.GA5478@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706191847.54157.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Please find the quick fix as per your suggestion below.

I've already done it myself. But I ended up doing it the other
way around -- making DEBUG_RODATA dependent on !KPROBES
because I figured KPROBES is more important than DEBUG_RODATA
and it is less confusing for the user this way.

-Andi
