Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYJMODq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYJMODq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYJMODd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:03:33 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36772 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYJMODc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:03:32 -0400
Date: Mon, 13 Oct 2008 17:02:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Phil Endecott <phil_wueww_endecott@chezphil.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu
Message-ID: <20081013140228.GG29938@cs181140183.pp.htv.fi>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org> <87zll8r86h.fsf@basil.nowhere.org> <20081013091848.7dcdaaac@infradead.org> <20081013133051.GL12131@one.firstfloor.org> <20081013093014.607c5925@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081013093014.607c5925@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> for Atom. 
> (586 scheduling sounds nice, but the pipelines are rather different.
> And the benchmarks don't lie..  ;-)

That sounds a bit dangerous since tune=generic is documented to change 
the semantics between gcc versions to better fit more recent CPUs
(there's even a small difference between gcc 4.2 and gcc 4.3):

          As new processors are deployed in the marketplace, the
          behavior of this option will change.  Therefore, if you
          upgrade to a newer version of GCC, the code generated option
          will change to reflect the processors that were most common
          when that version of GCC was released.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

