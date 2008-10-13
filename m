Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYJMNrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYJMNrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYJMNqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:46:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39645 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbYJMNqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:46:52 -0400
Date: Mon, 13 Oct 2008 15:53:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Phil Endecott <phil_wueww_endecott@chezphil.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu
Message-ID: <20081013135329.GM12131@one.firstfloor.org>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org> <87zll8r86h.fsf@basil.nowhere.org> <20081013091848.7dcdaaac@infradead.org> <20081013133051.GL12131@one.firstfloor.org> <20081013093014.607c5925@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013093014.607c5925@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 09:30:14AM -0400, Arjan van de Ven wrote:
> On Mon, 13 Oct 2008 15:30:51 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > Core2 instruction set with tune=generic is still the best to set.
> > 
> > Not sure that is true. These option are mostly for the compiler.
> 
> exactly, and our benchmarks show that tune=generic is best right now

So it doesn't matter as long as you set X86_GENERIC (and 
CONFIG_CC_OPTIMIZE_FOR_SIZE)

It would probably make sense to add a setting for those.

-Andi

-- 
ak@linux.intel.com
