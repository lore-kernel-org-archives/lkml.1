Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbXIRWOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbXIRWOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbXIRWOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:14:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbXIRWOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:14:32 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca>
	<20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 00:14:28 +0200
In-Reply-To: <46F04856.3010808@goop.org>
Message-ID: <p73myvjwri3.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
> It's a pity that gas seems to generate plain 0x90 nops rather than
> long-nop forms here.  I thought it could do that.

.p2align does it.

-Andi
