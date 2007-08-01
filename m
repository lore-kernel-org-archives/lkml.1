Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXHAS0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXHAS0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbXHAS0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:26:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60436 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbXHAS0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:26:14 -0400
Date: Wed, 1 Aug 2007 20:26:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
Message-ID: <20070801182611.GB20713@one.firstfloor.org>
References: <11859243121617-git-send-email-clameter@sgi.com> <p73ir7zplty.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But then the numbers are not comparable across systems.

That would only matter if you're interested in absolute system
performance of different systems.

But comparable performance testing in general only makes sense when you
only change one variable: either you change the hardware or
you change the software. If you change both at the same time
you'll never know where the difference comes from. 

I assume this facility is aimed at software performance testing:
this means it doesn't make much sense to compare numbers
between different systems; just relative numbers on the same
system with different software.

If you want absolute comparable system performance benchmarks I don't think
micro-instrumenting the kernel is a good approach.

But for relative performance cycles are fine. Anyways if you really
wanted to do ns it's possible too, but far more complicated to do correctly.

-Andi
