Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbXJPKAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbXJPKAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXJPJ75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:59:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:42907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbXJPJ75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:59:57 -0400
To: vgoyal@in.ibm.com
Cc: Bernhard Walle <bwalle@suse.de>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: [patch 0/2] Protect crashkernel against BSS overlap
References: <20071015115042.391348549@strauss.suse.de>
	<20071016054956.GA4659@in.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 16 Oct 2007 11:59:55 +0200
In-Reply-To: <20071016054956.GA4659@in.ibm.com>
Message-ID: <p738x63z8f8.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:

> Wouldn't it be better if we reserve the code, data and bss memory also
> using bootmem allocator and when somebody tries to reserve craskernel memory
> and if there is an overlap, boot memory allocator should scream?

Some x86 bootmem code right now relies on it not screaming (or at least not
erroring out). That would need to be fixed first. Or you make it a flag.
Would probably make sense, except that we already have too many bootmem
allocation variants :/

-Andi
