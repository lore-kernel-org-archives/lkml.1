Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbXBBMVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbXBBMVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbXBBMVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:21:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:45861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbXBBMVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:21:42 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
	<20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu>
From: Andi Kleen <ak@suse.de>
Date: 02 Feb 2007 14:22:16 +0100
In-Reply-To: <20070201130234.GA15257@elte.hu>
Message-ID: <p73abzwofsn.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> and for one of the most important IO 
> disciplines, networking, that is reality already.

Not 100% -- a few things in TCP/IP at least are blocking still.
Mostly relatively obscure things though.

Also the sockets model is currently incompatible with direct zero-copy RX/TX, 
which needs fixing.

-Andi
