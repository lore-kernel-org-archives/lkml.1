Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZFOLjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZFOLjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZFOLis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:38:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZFOLir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:38:47 -0400
Date: Mon, 15 Jun 2009 13:38:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615113848.GA23377@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop> <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615112827.GC6012@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:28:28PM +0200, Nick Piggin wrote:
> On Mon, Jun 15, 2009 at 01:22:05PM +0200, Nick Piggin wrote:
> > On Mon, Jun 15, 2009 at 08:39:48PM +1000, Benjamin Herrenschmidt wrote:
> > But I won't live with having it shit in our nice core code...
> > Well, at least I won't throw up my hands and give up this
> > early.
> 
> Just the principle, btw.

I have the same opinion for suspend/resume too, although
in that case I know less about the issues and if we
found that it indeed does make a random driver writers
life easier[*] then it might be a reason to do this. But
I still don't think that would give boot code a license to
just revert back to "I don't know or care, GFP_KERNEL pelase"

[*] and note that being unaware of your context I don't
think is making life easier automatically.



