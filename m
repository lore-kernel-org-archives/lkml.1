Return-Path: <linux-kernel-owner+w=401wt.eu-S965799AbXHaODr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965799AbXHaODr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965344AbXHaODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:03:36 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50055 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965228AbXHaODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:03:34 -0400
Date: Fri, 31 Aug 2007 08:03:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Hellwig <hch@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Satyam Sharma <satyam@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Joe Perches <joe@perches.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial - constify sched.h
Message-ID: <20070831140332.GB14130@parisc-linux.org>
References: <1188247231.18004.129.camel@localhost> <20070827213323.GA1759@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0708302120290.24730@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.999.0708310121121.28360@enigma.security.iitk.ac.in> <Pine.LNX.4.64.0708302247070.10266@fbirervta.pbzchgretzou.qr> <20070831135323.GA24509@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831135323.GA24509@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 02:53:23PM +0100, Christoph Hellwig wrote:
> On Thu, Aug 30, 2007 at 10:55:49PM +0200, Jan Engelhardt wrote:
> > "those callers". There was _exactly one_ caller, and that was an out-of-tree
> > module. There were not any in-kernel callers before, and it did not generate
> > any warning. That is perhaps why no one had constified it before me. This does
> > not mean we should wait for a caller to pop up before constifying IMHO.
> 
> In this case we should just kill it instead of messing with constness.

I think Jan mis-spoke -- there were no in-kernel callers calling it with
a const argument.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
