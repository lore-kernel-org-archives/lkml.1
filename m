Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbYJMNYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbYJMNYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYJMNYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:24:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42967 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYJMNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:24:13 -0400
Date: Mon, 13 Oct 2008 15:30:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Phil Endecott <phil_wueww_endecott@chezphil.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu
Message-ID: <20081013133051.GL12131@one.firstfloor.org>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org> <87zll8r86h.fsf@basil.nowhere.org> <20081013091848.7dcdaaac@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013091848.7dcdaaac@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 09:18:48AM -0400, Arjan van de Ven wrote:
> On Mon, 13 Oct 2008 14:28:06 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > "Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:
> > 
> > > Am I right in thinking that CONFIG_MCORE2 is the correct choice for
> > > an Intel Atom? 
> > 
> > No, Atom is completely different from a Core2.
> > 
> > Right now 586 or 686 is a reasonable choice.
> 
> actually 586 is completely wrong.

It is nearest in scheduling at least. You'll lose CMOV, but that's
not a big loss.

> Core2 instruction set with tune=generic is still the best to set.

Not sure that is true. These option are mostly for the compiler.

-Andi

-- 
ak@linux.intel.com
