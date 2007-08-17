Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbXHQOTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbXHQOTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXHQOTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:19:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762165AbXHQOTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:19:08 -0400
Date: Fri, 17 Aug 2007 10:19:00 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hajime Inoue <hinoue@ccsl.carleton.ca>, linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
Message-ID: <20070817141900.GA7223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Hajime Inoue <hinoue@ccsl.carleton.ca>,
	linux-kernel@vger.kernel.org
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca> <20070814000956.7c8929dd@the-village.bc.nu> <46C1E5F5.9050702@ccsl.carleton.ca> <p73zm0tnbf8.fsf@bingen.suse.de> <20070814234206.76121d02@the-village.bc.nu> <20070814224835.GJ23308@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814224835.GJ23308@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 12:48:35AM +0200, Andi Kleen wrote:

 > > > In general the .data protection is only considered a debugging
 > > > feature. I don't know why Fedora enables it in their production
 > > > kernels.
 > > 
 > > That would be because we think you are wrong 8)
 > 
 > Well, it might at best buy you a few weeks/months in
 > terms of the exploit arms race, but thrash your user's TLBs
 > forever.

Show me a single situation where this matters.
When we first enabled, we tried both benchmarks and real-world
loads, and it didn't matter at all.  Unless something fundamental
has changed since then, the story should still be the same.

	Dave

-- 
http://www.codemonkey.org.uk
